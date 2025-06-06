import 'app_database.dart';
import '../models/sale_model.dart';

class SaleLocalDatasource {
  final AppDatabase _db = AppDatabase();

  Future<int> insertSale(SaleModel sale) async {
    final db = await _db.database;
    final saleId = await db.insert('sales', {
      'sale_date': sale.saleDate,
      'total_amount': sale.totalAmount,
    });
    for (final item in sale.items) {
      await db.insert('sale_items', {
        'sale_id': saleId,
        'product_id': item.productId,
        'quantity': item.quantity,
        'price_at_sale': item.priceAtSale,
      });
      // Reduce stock del producto
      await db.rawUpdate('UPDATE products SET stock = stock - ? WHERE id = ?', [
        item.quantity,
        item.productId,
      ]);
    }
    return saleId;
  }

  Future<List<SaleModel>> getSales() async {
    final db = await _db.database;
    final salesMaps = await db.query('sales', orderBy: 'sale_date DESC');
    List<SaleModel> sales = [];
    for (final saleMap in salesMaps) {
      final saleId = saleMap['id'] as int;
      final itemsMaps = await db.query(
        'sale_items',
        where: 'sale_id = ?',
        whereArgs: [saleId],
      );
      final items = itemsMaps.map((e) => SaleItemModel.fromMap(e)).toList();
      sales.add(SaleModel.fromMap(saleMap, items));
    }
    return sales;
  }

  Future<SaleModel?> getSaleById(int id) async {
    final db = await _db.database;
    final salesMaps = await db.query('sales', where: 'id = ?', whereArgs: [id]);
    if (salesMaps.isEmpty) return null;
    final itemsMaps = await db.query(
      'sale_items',
      where: 'sale_id = ?',
      whereArgs: [id],
    );
    final items = itemsMaps.map((e) => SaleItemModel.fromMap(e)).toList();
    return SaleModel.fromMap(salesMaps.first, items);
  }
}
