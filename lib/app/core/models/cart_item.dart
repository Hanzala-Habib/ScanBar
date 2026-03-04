class CartItem {
  const CartItem({
    this.id,
    required this.barcode,
    required this.name,
    required this.price,
    required this.quantity,
  });

  final int? id;
  final String barcode;
  final String name;
  final double price;
  final int quantity;

  double get subtotal => price * quantity;

  CartItem copyWith({
    int? id,
    String? barcode,
    String? name,
    double? price,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'barcode': barcode,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] as int?,
      barcode: map['barcode'] as String,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'] as int,
    );
  }
}
