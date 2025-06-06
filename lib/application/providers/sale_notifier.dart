import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/sale_entity.dart';
import '../../data/repositories/sale_repository_impl.dart';

class SaleNotifier extends StateNotifier<AsyncValue<void>> {
  SaleNotifier() : super(const AsyncValue.data(null));

  Future<void> addSale(SaleEntity sale) async {
    state = const AsyncValue.loading();
    try {
      await SaleRepositoryImpl().addSale(sale);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final saleNotifierProvider =
    StateNotifierProvider<SaleNotifier, AsyncValue<void>>(
      (ref) => SaleNotifier(),
    );
