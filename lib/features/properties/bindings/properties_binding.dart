import 'package:get/get.dart';

import '../../../core/network/api_client.dart';
import '../../../data/providers/property_provider.dart';
import '../../../data/repositories/property_repository.dart';
import '../controllers/properties_controller.dart';

class PropertiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PropertyProvider(Get.find<ApiClient>()));
    Get.lazyPut(() => PropertyRepository(Get.find()));
    Get.lazyPut(() => PropertiesController(Get.find()));
  }
}
