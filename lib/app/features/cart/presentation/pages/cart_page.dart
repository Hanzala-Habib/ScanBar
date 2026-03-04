import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../controllers/cart_controller.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/total_card.dart';

class CartPage extends GetView<CartController> {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ScanBar Cart'),
        actions: [
          IconButton(
            onPressed: controller.clearAll,
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'Clear cart',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openScanner(context),
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Scan barcode'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.items.isEmpty) {
                return const Center(
                  child: Text(
                    'No items yet. Tap "Scan barcode" to start adding products.',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return AnimatedList(
                key: controller.animatedListKey,
                initialItemCount: controller.items.length,
                itemBuilder: (context, index, animation) {
                  final item = controller.items[index];
                  return SizeTransition(
                    sizeFactor: animation,
                    child: CartItemTile(
                      item: item,
                      onIncrease: () => controller.increaseQty(item),
                      onDecrease: () => controller.decreaseQty(item),
                    ),
                  );
                },
              );
            }),
          ),
          Obx(() => TotalCard(total: controller.total)),
        ],
      ),
    );
  }

  Future<void> _openScanner(BuildContext context) async {
    bool scanned = false;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          child: Stack(
            children: [
              MobileScanner(
                onDetect: (capture) {
                  if (scanned) return;
                  final code = capture.barcodes.first.rawValue;
                  if (code == null || code.isEmpty) return;

                  scanned = true;
                  controller.handleBarcode(code);
                  Navigator.of(context).pop();
                },
              ),
              Positioned(
                top: 12,
                right: 12,
                child: CircleAvatar(
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
