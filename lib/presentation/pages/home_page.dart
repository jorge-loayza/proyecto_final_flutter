import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'product_list_page.dart';
import 'sale_form_page.dart';
import 'sales_history_page.dart';
import '../../domain/entities/product_entity.dart';
import '../../application/providers/product_notifier.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;
  ProductEntity? _selectedProduct;
  int _salesHistoryKey = DateTime.now().millisecondsSinceEpoch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tienda de Abarrotes')),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          ProductListPage(
            onSell: (product) {
              setState(() {
                _selectedProduct = product;
                _selectedIndex = 1;
              });
            },
          ),
          _selectedProduct == null
              ? const Center(child: Text('Selecciona un producto para vender'))
              : SaleFormPage(
                product: _selectedProduct!,
                onSaleCompleted: (sale) async {
                  await ref
                      .read(productNotifierProvider.notifier)
                      .loadProducts();
                  setState(() {
                    _selectedProduct = null;
                    _selectedIndex = 0;
                    _salesHistoryKey = DateTime.now().millisecondsSinceEpoch;
                  });
                },
                onCancel: () {
                  setState(() {
                    _selectedProduct = null;
                    _selectedIndex = 0;
                  });
                },
              ),
          SalesHistoryPage(key: ValueKey(_salesHistoryKey)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Productos'),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historial de Ventas',
          ),
        ],
        currentIndex: _selectedIndex == 2 ? 1 : 0,
        onTap: (index) {
          setState(() {
            if (index == 0) {
              _selectedIndex = 0;
            } else if (index == 1) {
              _selectedIndex = 2;
            }
          });
        },
      ),
    );
  }
}
