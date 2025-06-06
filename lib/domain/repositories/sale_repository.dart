import '../entities/sale_entity.dart';

abstract class ISaleRepository {
  Future<List<SaleEntity>> getSales();
  Future<void> addSale(SaleEntity sale);
  Future<SaleEntity?> getSaleById(int id);
}
