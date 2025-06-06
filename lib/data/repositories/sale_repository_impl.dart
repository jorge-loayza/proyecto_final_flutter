import '../../domain/entities/sale_entity.dart';
import '../../domain/repositories/sale_repository.dart';
import '../datasources/sale_local_datasource.dart';
import '../models/sale_model.dart';

class SaleRepositoryImpl implements ISaleRepository {
  final SaleLocalDatasource datasource = SaleLocalDatasource();

  @override
  Future<void> addSale(SaleEntity sale) async {
    final saleModel = SaleModel.fromEntity(sale);
    await datasource.insertSale(saleModel);
  }

  @override
  Future<SaleEntity?> getSaleById(int id) async {
    final saleModel = await datasource.getSaleById(id);
    return saleModel?.toEntity();
  }

  @override
  Future<List<SaleEntity>> getSales() async {
    final sales = await datasource.getSales();
    return sales.map((e) => e.toEntity()).toList();
  }
}
