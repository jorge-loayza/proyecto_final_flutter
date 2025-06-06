import '../../domain/entities/product_entity.dart';

class ProductModel {
  final int? id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String qrCode;

  ProductModel({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.qrCode,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      stock: map['stock'],
      qrCode: map['qr_code'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'qr_code': qrCode,
    };
  }

  ProductEntity toEntity() => ProductEntity(
    id: id,
    name: name,
    description: description,
    price: price,
    stock: stock,
    qrCode: qrCode,
  );

  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      stock: entity.stock,
      qrCode: entity.qrCode,
    );
  }
}
