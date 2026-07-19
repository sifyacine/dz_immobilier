import 'package:get/get.dart';

import '../../../core/network/api_client.dart';
import '../../../data/providers/property_provider.dart';
import '../../../data/repositories/property_repository.dart';
import '../controllers/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    // PropertyProvider / Repository may already exist from PropertiesBinding;
    // lazyPut with fenix:true ensures they're recreated if disposed.
    Get.lazyPut<PropertyProvider>(
      () => PropertyProvider(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<PropertyRepository>(
      () => PropertyRepository(Get.find<PropertyProvider>()),
      fenix: true,
    );
    Get.lazyPut<SearchController>(
      () => SearchController(Get.find<PropertyRepository>()),
    );
  }
}
