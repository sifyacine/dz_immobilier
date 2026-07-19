import 'package:get/get.dart';

import '../../../core/network/api_client.dart';
import '../../../core/storage/storage_service.dart';
import '../../../data/providers/property_provider.dart';
import '../../../data/repositories/property_repository.dart';
import '../controllers/property_detail_controller.dart';

class PropertyDetailBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PropertyProvider>()) {
      Get.lazyPut(() => PropertyProvider(Get.find<ApiClient>()));
    }
    if (!Get.isRegistered<PropertyRepository>()) {
      Get.lazyPut(() => PropertyRepository(Get.find()));
    }
    Get.lazyPut(() => PropertyDetailController(
          Get.find(),
          Get.find<StorageService>(),
        ));
  }
}
