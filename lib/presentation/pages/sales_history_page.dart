import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/sale_repository_impl.dart';
import '../../domain/entities/sale_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../application/providers/product_notifier.dart';

class SalesHistoryPage extends ConsumerStatefulWidget {
  const SalesHistoryPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SalesHistoryPage> createState() => _SalesHistoryPageState();
}

class _SalesHistoryPageState extends ConsumerState<SalesHistoryPage> {
  late Future<List<SaleEntity>> _salesFuture;

  @override
  void initState() {
    super.initState();
    _salesFuture = SaleRepositoryImpl().getSales();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Historial de Ventas')),
      body: productsAsync.when(
        data:
            (products) => FutureBuilder<List<SaleEntity>>(
              future: _salesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final sales = snapshot.data ?? [];
                if (sales.isEmpty) {
                  return const Center(
                    child: Text('No hay ventas registradas.'),
                  );
                }
                return ListView.builder(
                  itemCount: sales.length,
                  itemBuilder: (context, index) {
                    final sale = sales[index];
                    // Construir string con los productos vendidos, cantidades y precios
                    final productosVendidos = sale.items
                        .map((item) {
                          ProductEntity? product;
                          try {
                            product = products.firstWhere(
                              (p) => p.id == item.productId,
                            );
                          } catch (_) {
                            product = null;
                          }
                          final productName =
                              product?.name ?? 'Producto eliminado';
                          return '$productName x${item.quantity} (S/ ${item.priceAtSale})';
                        })
                        .join(', ');
                    return ListTile(
                      title: Text(
                        'Venta #${sale.id} - S/ ${sale.totalAmount.toStringAsFixed(2)}',
                      ),
                      subtitle: Text(
                        'Fecha: ${sale.saleDate}\nProductos: $productosVendidos',
                      ),
                      onTap:
                          () => showDialog(
                            context: context,
                            builder:
                                (_) => AlertDialog(
                                  title: const Text('Detalle de Venta'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children:
                                        sale.items.map((item) {
                                          ProductEntity? product;
                                          try {
                                            product = products.firstWhere(
                                              (p) => p.id == item.productId,
                                            );
                                          } catch (_) {
                                            product = null;
                                          }
                                          final productName =
                                              product?.name ??
                                              'Producto eliminado';
                                          return Text(
                                            'Producto: $productName\nCantidad: ${item.quantity}\nPrecio: S/ ${item.priceAtSale}',
                                          );
                                        }).toList(),
                                  ),
                                ),
                          ),
                    );
                  },
                );
              },
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: ${e}')),
      ),
    );
  }
}
