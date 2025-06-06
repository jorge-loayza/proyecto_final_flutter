import '../../domain/entities/sale_entity.dart';

class SaleModel {
  final int? id;
  final String saleDate;
  final double totalAmount;
  final List<SaleItemModel> items;

  SaleModel({
    this.id,
    required this.saleDate,
    required this.totalAmount,
    required this.items,
  });

  factory SaleModel.fromMap(
    Map<String, dynamic> map,
    List<SaleItemModel> items,
  ) {
    return SaleModel(
      id: map['id'],
      saleDate: map['sale_date'],
      totalAmount: map['total_amount'],
      items: items,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'sale_date': saleDate, 'total_amount': totalAmount};
  }

  SaleEntity toEntity() => SaleEntity(
    id: id,
    saleDate: DateTime.parse(saleDate),
    totalAmount: totalAmount,
    items: items.map((e) => e.toEntity()).toList(),
  );

  factory SaleModel.fromEntity(SaleEntity entity) {
    return SaleModel(
      id: entity.id,
      saleDate: entity.saleDate.toIso8601String(),
      totalAmount: entity.totalAmount,
      items: entity.items.map((e) => SaleItemModel.fromEntity(e)).toList(),
    );
  }
}

class SaleItemModel {
  final int? id;
  final int saleId;
  final int productId;
  final int quantity;
  final double priceAtSale;

  SaleItemModel({
    this.id,
    required this.saleId,
    required this.productId,
    required this.quantity,
    required this.priceAtSale,
  });

  factory SaleItemModel.fromMap(Map<String, dynamic> map) {
    return SaleItemModel(
      id: map['id'],
      saleId: map['sale_id'],
      productId: map['product_id'],
      quantity: map['quantity'],
      priceAtSale: map['price_at_sale'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sale_id': saleId,
      'product_id': productId,
      'quantity': quantity,
      'price_at_sale': priceAtSale,
    };
  }

  SaleItemEntity toEntity() => SaleItemEntity(
    id: id,
    productId: productId,
    quantity: quantity,
    priceAtSale: priceAtSale,
  );

  factory SaleItemModel.fromEntity(SaleItemEntity entity) {
    return SaleItemModel(
      id: entity.id,
      saleId: 0,
      productId: entity.productId,
      quantity: entity.quantity,
      priceAtSale: entity.priceAtSale,
    );
  }
}
