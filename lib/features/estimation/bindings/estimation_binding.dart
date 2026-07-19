import 'package:get/get.dart';

import '../../../core/network/api_client.dart';
import '../../../data/providers/estimation_provider.dart';
import '../../../data/repositories/estimation_repository.dart';
import '../controllers/estimation_controller.dart';

class EstimationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EstimationProvider(Get.find<ApiClient>()));
    Get.lazyPut(() => EstimationRepository(Get.find()));
    Get.lazyPut<EstimationController>(() => EstimationController(Get.find()));
  }
}
