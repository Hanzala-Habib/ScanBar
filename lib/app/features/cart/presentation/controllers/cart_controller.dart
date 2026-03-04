import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/models/cart_item.dart';
import '../../../../core/services/product_catalog_service.dart';
import '../../data/domain/cart_repository.dart';

class CartController extends GetxController {
  CartController({
    required CartRepository repository,
    required ProductCatalogService catalogService,
  })  : _repository = repository,
        _catalogService = catalogService;

  final CartRepository _repository;
  final ProductCatalogService _catalogService;

  final items = <CartItem>[].obs;
  final isLoading = false.obs;

  final animatedListKey = GlobalKey<AnimatedListState>();

  double get total => items.fold(0, (sum, item) => sum + item.subtotal);

  @override
  void onInit() {
    super.onInit();
    loadItems();
  }

  Future<void> loadItems() async {
    isLoading.value = true;
    final loaded = await _repository.getAllItems();
    items.assignAll(loaded);
    isLoading.value = false;
  }

  Future<void> handleBarcode(String barcode) async {
    if (barcode.isEmpty) return;

    final product = _catalogService.resolveProduct(barcode);
    final cartItem = CartItem(
      barcode: product.barcode,
      name: product.name,
      price: product.price,
      quantity: 1,
    );

    final updatedOrInserted = await _repository.upsertScannedItem(cartItem);
    final index = items.indexWhere((e) => e.barcode == barcode);

    if (index == -1) {
      items.add(updatedOrInserted);
      animatedListKey.currentState?.insertItem(items.length - 1);
    } else {
      items[index] = updatedOrInserted;
    }

    items.refresh();
    update();
  }

  Future<void> increaseQty(CartItem item) async {
    if (item.id == null) return;
    final newQty = item.quantity + 1;
    await _repository.updateQuantity(id: item.id!, quantity: newQty);
    _replace(item.copyWith(quantity: newQty));
  }

  Future<void> decreaseQty(CartItem item) async {
    if (item.id == null) return;
    final newQty = item.quantity - 1;
    await _repository.updateQuantity(id: item.id!, quantity: newQty);

    if (newQty <= 0) {
      final index = items.indexWhere((element) => element.id == item.id);
      if (index != -1) {
        final removed = items.removeAt(index);
        animatedListKey.currentState?.removeItem(
          index,
          (context, animation) => SizeTransition(
            sizeFactor: animation,
            child: _RemovedItemCard(item: removed),
          ),
        );
      }
    } else {
      _replace(item.copyWith(quantity: newQty));
    }

    items.refresh();
    update();
  }

  Future<void> clearAll() async {
    await _repository.clearCart();
    for (var i = items.length - 1; i >= 0; i--) {
      final removed = items.removeAt(i);
      animatedListKey.currentState?.removeItem(
        i,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: _RemovedItemCard(item: removed),
        ),
      );
    }
    items.refresh();
    update();
  }

  void _replace(CartItem newItem) {
    final index = items.indexWhere((element) => element.id == newItem.id);
    if (index != -1) {
      items[index] = newItem;
    }
  }
}

class _RemovedItemCard extends StatelessWidget {
  const _RemovedItemCard({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(item.name),
        subtitle: Text('Removed from cart'),
      ),
    );
  }
}
