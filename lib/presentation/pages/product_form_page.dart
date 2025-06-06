import 'package:flutter/material.dart';
import '../../domain/entities/product_entity.dart';

class ProductFormPage extends StatefulWidget {
  final ProductEntity? product;
  final void Function(ProductEntity) onSave;
  const ProductFormPage({Key? key, this.product, required this.onSave})
    : super(key: key);

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  late double _price;
  late int _stock;
  late String _qrCode;

  @override
  void initState() {
    super.initState();
    _name = widget.product?.name ?? '';
    _description = widget.product?.description ?? '';
    _price = widget.product?.price ?? 0.0;
    _stock = widget.product?.stock ?? 0;
    _qrCode = widget.product?.qrCode ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product == null ? 'Nuevo Producto' : 'Editar Producto',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator:
                    (v) => v == null || v.isEmpty ? 'Campo obligatorio' : null,
                onSaved: (v) => _name = v!,
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator:
                    (v) => v == null || v.isEmpty ? 'Campo obligatorio' : null,
                onSaved: (v) => _description = v!,
              ),
              TextFormField(
                initialValue: _price == 0.0 ? '' : _price.toString(),
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final p = double.tryParse(v ?? '');
                  if (p == null || p < 0) return 'Precio inválido';
                  return null;
                },
                onSaved: (v) => _price = double.parse(v!),
              ),
              TextFormField(
                initialValue: _stock == 0 ? '' : _stock.toString(),
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final s = int.tryParse(v ?? '');
                  if (s == null || s < 0) return 'Stock inválido';
                  return null;
                },
                onSaved: (v) => _stock = int.parse(v!),
              ),
              TextFormField(
                initialValue: _qrCode,
                decoration: const InputDecoration(labelText: 'Código QR'),
                validator:
                    (v) => v == null || v.isEmpty ? 'Campo obligatorio' : null,
                onSaved: (v) => _qrCode = v!,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.onSave(
                      ProductEntity(
                        id: widget.product?.id,
                        name: _name,
                        description: _description,
                        price: _price,
                        stock: _stock,
                        qrCode: _qrCode,
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: Text(widget.product == null ? 'Crear' : 'Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
