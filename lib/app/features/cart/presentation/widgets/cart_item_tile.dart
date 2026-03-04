import 'package:flutter/material.dart';

import '../../../../core/models/cart_item.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
  });

  final CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('Price: \$${item.price.toStringAsFixed(2)}\nBarcode: ${item.barcode}'),
        isThreeLine: true,
        trailing: SizedBox(
          width: 122,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(onPressed: onDecrease, icon: const Icon(Icons.remove_circle_outline)),
              Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              IconButton(onPressed: onIncrease, icon: const Icon(Icons.add_circle_outline)),
            ],
          ),
        ),
      ),
    );
  }
}
