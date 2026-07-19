import 'package:get/get.dart';

import '../../../core/network/api_client.dart';
import '../../../data/providers/estimation_provider.dart';
import '../../../data/repositories/estimation_repository.dart';
import '../controllers/speed30_controller.dart';

class Speed30Binding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<EstimationProvider>()) {
      Get.lazyPut(() => EstimationProvider(Get.find<ApiClient>()));
    }
    if (!Get.isRegistered<EstimationRepository>()) {
      Get.lazyPut(() => EstimationRepository(Get.find()));
    }
    Get.lazyPut(() => Speed30Controller(Get.find()));
  }
}
