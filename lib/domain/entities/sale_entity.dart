class SaleEntity {
  final int? id;
  final DateTime saleDate;
  final double totalAmount;
  final List<SaleItemEntity> items;

  SaleEntity({
    this.id,
    required this.saleDate,
    required this.totalAmount,
    required this.items,
  });
}

class SaleItemEntity {
  final int? id;
  final int productId;
  final int quantity;
  final double priceAtSale;

  SaleItemEntity({
    this.id,
    required this.productId,
    required this.quantity,
    required this.priceAtSale,
  });
}
