import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/product_notifier.dart';
import '../../domain/entities/product_entity.dart';
import 'sale_form_page.dart';
import 'product_form_page.dart';
import 'qr_scan_page.dart';

class ProductListPage extends ConsumerWidget {
  final void Function(ProductEntity) onSell;
  const ProductListPage({Key? key, required this.onSell}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchar cambios y recargar productos cuando se vuelve a la pantalla
    ref.listen(productNotifierProvider, (previous, next) {
      if (previous != next) {
        ref.read(productNotifierProvider.notifier).loadProducts();
      }
    });

    final productsAsync = ref.watch(productNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              // Crear producto
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (_) => ProductFormPage(
                        onSave: (product) async {
                          await ref
                              .read(productNotifierProvider.notifier)
                              .addProduct(product);
                        },
                      ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Escanear QR para vender',
            onPressed: () async {
              // Eliminar verificación de permisos manuales, abrir directamente el escáner
              String? qrCode;
              bool scanned = false;
              qrCode = await Navigator.of(context).push<String>(
                MaterialPageRoute(
                  builder:
                      (_) => QrScanPage(
                        onQrRead: (code) {
                          if (!scanned && context.mounted) {
                            scanned = true;
                            Navigator.of(context).pop(code);
                          }
                        },
                      ),
                ),
              );
              if (qrCode == null) return;
              final products = ref.read(productNotifierProvider).value ?? [];
              final productList =
                  products.where((p) => p.qrCode == qrCode).toList();
              if (productList.isEmpty) {
                if (context.mounted) {
                  showDialog(
                    context: context,
                    builder:
                        (_) => const AlertDialog(
                          title: Text('Producto no encontrado'),
                          content: Text(
                            'No se encontró un producto con ese código.',
                          ),
                        ),
                  );
                }
                return;
              }
              final product = productList.first;
              if (product.stock == 0) {
                if (context.mounted) {
                  showDialog(
                    context: context,
                    builder:
                        (_) => const AlertDialog(
                          title: Text('Sin stock'),
                          content: Text(
                            'El producto no tiene stock disponible.',
                          ),
                        ),
                  );
                }
                return;
              }
              onSell(product);
            },
          ),
        ],
      ),
      body: productsAsync.when(
        data:
            (products) => ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final isOutOfStock = product.stock == 0;
                return ListTile(
                  leading:
                      isOutOfStock
                          ? const Icon(Icons.warning, color: Colors.red)
                          : null,
                  title: Text(product.name),
                  subtitle: Text('Stock: ${product.stock}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (_) => ProductFormPage(
                                    product: product,
                                    onSave: (updated) async {
                                      await ref
                                          .read(
                                            productNotifierProvider.notifier,
                                          )
                                          .updateProduct(updated);
                                    },
                                  ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (_) => AlertDialog(
                                  title: const Text('Eliminar producto'),
                                  content: const Text(
                                    '¿Estás seguro de eliminar este producto?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () =>
                                              Navigator.of(context).pop(false),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(context).pop(true),
                                      child: const Text('Eliminar'),
                                    ),
                                  ],
                                ),
                          );
                          if (confirm == true) {
                            await ref
                                .read(productNotifierProvider.notifier)
                                .deleteProduct(product.id!);
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.sell),
                        onPressed: isOutOfStock ? null : () => onSell(product),
                        color: isOutOfStock ? Colors.grey : null,
                      ),
                    ],
                  ),
                );
              },
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
