import '../../domain/entities/product_entity.dart';

class ProductController {
  // Métodos para exponer lógica de UI y validaciones
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre es obligatorio';
    }
    return null;
  }

  String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'El precio es obligatorio';
    }
    final price = double.tryParse(value);
    if (price == null || price < 0) {
      return 'Precio inválido';
    }
    return null;
  }

  // Otros métodos de validación y lógica de presentación
}
