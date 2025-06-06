import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/repositories/product_repository.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../data/datasources/product_local_datasource.dart';

class ProductNotifier extends StateNotifier<AsyncValue<List<ProductEntity>>> {
  final GetProductsUseCase getProductsUseCase;
  final IProductRepository repository;

  ProductNotifier(this.getProductsUseCase, this.repository)
    : super(const AsyncValue.loading()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final products = await getProductsUseCase();
      state = AsyncValue.data(products);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addProduct(ProductEntity product) async {
    await repository.addProduct(product);
    await loadProducts();
  }

  Future<void> updateProduct(ProductEntity product) async {
    await repository.updateProduct(product);
    await loadProducts();
  }

  Future<void> deleteProduct(int id) async {
    await repository.deleteProduct(id);
    await loadProducts();
  }
}

final productNotifierProvider =
    StateNotifierProvider<ProductNotifier, AsyncValue<List<ProductEntity>>>((
      ref,
    ) {
      final repo = ProductRepositoryImpl(ProductLocalDatasource());
      return ProductNotifier(GetProductsUseCase(repo), repo);
    });
