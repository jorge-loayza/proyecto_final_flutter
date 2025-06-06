import 'app_database.dart';
import '../models/product_model.dart';
import 'package:sqflite/sqflite.dart';

class ProductLocalDatasource {
  final AppDatabase _db = AppDatabase();

  Future<List<ProductModel>> getProducts() async {
    final db = await _db.database;
    final maps = await db.query('products');
    return maps.map((e) => ProductModel.fromMap(e)).toList();
  }

  Future<void> insertProduct(ProductModel product) async {
    final db = await _db.database;
    await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateProduct(ProductModel product) async {
    final db = await _db.database;
    await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<void> deleteProduct(int id) async {
    final db = await _db.database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<ProductModel?> getProductByQrCode(String qrCode) async {
    final db = await _db.database;
    final maps = await db.query(
      'products',
      where: 'qr_code = ?',
      whereArgs: [qrCode],
    );
    if (maps.isNotEmpty) {
      return ProductModel.fromMap(maps.first);
    }
    return null;
  }
}
