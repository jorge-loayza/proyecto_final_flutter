class ProductEntity {
  final int? id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String qrCode;

  ProductEntity({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.qrCode,
  });
}
