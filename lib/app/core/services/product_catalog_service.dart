import '../models/product.dart';

class ProductCatalogService {
  ProductCatalogService();

  // Placeholder in-memory catalog; this could be replaced by API-backed lookup.
  final Map<String, Product> _catalog = {
    '8901491101179': const Product(barcode: '8901491101179', name: 'Milk 1L', price: 2.45),
    '0123456789012': const Product(barcode: '0123456789012', name: 'Bread Loaf', price: 1.75),
    '9988776655443': const Product(barcode: '9988776655443', name: 'Apple Pack', price: 3.10),
    '1234567890128': const Product(barcode: '1234567890128', name: 'Eggs 12 pcs', price: 4.25),
  };

  Product resolveProduct(String barcode) {
    return _catalog[barcode] ?? Product(barcode: barcode, name: 'Unknown Item ($barcode)', price: 1.0);
  }
}
