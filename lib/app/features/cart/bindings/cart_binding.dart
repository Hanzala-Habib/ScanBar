import 'package:get/get.dart';

import '../../../core/db/app_database.dart';
import '../../../core/services/product_catalog_service.dart';
import '../data/domain/cart_repository.dart';
import '../presentation/controllers/cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AppDatabase.instance, permanent: true);
    Get.put(ProductCatalogService(), permanent: true);
    Get.put(CartRepository(Get.find<AppDatabase>()), permanent: true);
    Get.put(
      CartController(
        repository: Get.find<CartRepository>(),
        catalogService: Get.find<ProductCatalogService>(),
      ),
    );
  }
}
