import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/theme/app_theme.dart';
import 'features/cart/bindings/cart_binding.dart';
import 'features/cart/presentation/pages/cart_page.dart';

class ScanBarApp extends StatelessWidget {
  const ScanBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ScanBar',
      theme: AppTheme.lightTheme,
      initialBinding: CartBinding(),
      home: const CartPage(),
    );
  }
}
