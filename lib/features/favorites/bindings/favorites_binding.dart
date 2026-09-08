import 'package:get/get.dart';

import '../../../core/network/api_client.dart';
import '../../../core/storage/storage_service.dart';
import '../../../data/providers/property_provider.dart';
import '../../../data/repositories/property_repository.dart';
import '../controllers/favorites_controller.dart';

class FavoritesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PropertyProvider(Get.find<ApiClient>()));
    Get.lazyPut(() => PropertyRepository(Get.find()));
    Get.lazyPut<FavoritesController>(
        () => FavoritesController(Get.find(), Get.find<StorageService>()));
  }
}
