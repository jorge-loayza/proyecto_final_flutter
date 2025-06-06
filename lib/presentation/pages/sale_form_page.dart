import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/sale_entity.dart';
import '../../application/providers/sale_notifier.dart';

class SaleFormPage extends ConsumerStatefulWidget {
  final ProductEntity product;
  final void Function(SaleEntity) onSaleCompleted;
  final VoidCallback? onCancel;
  const SaleFormPage({
    Key? key,
    required this.product,
    required this.onSaleCompleted,
    this.onCancel,
  }) : super(key: key);

  @override
  ConsumerState<SaleFormPage> createState() => _SaleFormPageState();
}

class _SaleFormPageState extends ConsumerState<SaleFormPage> {
  final _formKey = GlobalKey<FormState>();
  int _quantity = 1;
  String? _stockError;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final saleState = ref.watch(saleNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Venta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Producto: ${product.name}',
                style: const TextStyle(fontSize: 18),
              ),
              Text('Precio: S/ ${product.price.toStringAsFixed(2)}'),
              Text('Stock disponible: ${product.stock}'),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: '1',
                decoration: InputDecoration(
                  labelText: 'Cantidad a vender',
                  errorText: _stockError,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final qty = int.tryParse(value ?? '');
                  if (qty == null || qty < 1) return 'Cantidad inválida';
                  if (qty > product.stock) return 'No hay suficiente stock';
                  return null;
                },
                onChanged: (value) {
                  final qty = int.tryParse(value);
                  setState(() {
                    if (qty != null && qty > product.stock) {
                      _stockError = 'No hay suficiente stock';
                    } else {
                      _stockError = null;
                    }
                  });
                },
                onSaved: (value) {
                  _quantity = int.parse(value!);
                },
              ),
              const SizedBox(height: 24),
              saleState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              final sale = SaleEntity(
                                saleDate: DateTime.now(),
                                totalAmount: product.price * _quantity,
                                items: [
                                  SaleItemEntity(
                                    productId: product.id!,
                                    quantity: _quantity,
                                    priceAtSale: product.price,
                                  ),
                                ],
                              );
                              await ref
                                  .read(saleNotifierProvider.notifier)
                                  .addSale(sale);
                              if (!mounted) return;
                              if (ref.read(saleNotifierProvider).hasError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Error al registrar la venta.',
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Venta registrada con éxito.',
                                    ),
                                  ),
                                );
                                widget.onSaleCompleted(sale);
                                Future.delayed(
                                  const Duration(milliseconds: 400),
                                  () {
                                    if (mounted) Navigator.of(context).pop();
                                  },
                                );
                              }
                            }
                          },
                          child: const Text('Confirmar Venta'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            if (widget.onCancel != null) {
                              widget.onCancel!();
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('Cancelar'),
                        ),
                      ),
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
