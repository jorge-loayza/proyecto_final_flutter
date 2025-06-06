import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements IProductRepository {
  final ProductLocalDatasource datasource;

  ProductRepositoryImpl(this.datasource);

  @override
  Future<List<ProductEntity>> getProducts() async {
    final models = await datasource.getProducts();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> addProduct(ProductEntity product) async {
    await datasource.insertProduct(ProductModel.fromEntity(product));
  }

  @override
  Future<void> updateProduct(ProductEntity product) async {
    await datasource.updateProduct(ProductModel.fromEntity(product));
  }

  @override
  Future<void> deleteProduct(int id) async {
    await datasource.deleteProduct(id);
  }

  @override
  Future<ProductEntity?> getProductByQrCode(String qrCode) async {
    final model = await datasource.getProductByQrCode(qrCode);
    return model?.toEntity();
  }
}
