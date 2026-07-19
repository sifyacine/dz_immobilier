import 'package:get/get.dart';

import '../../../core/network/api_client.dart';
import '../../../data/providers/simulation_provider.dart';
import '../../../data/repositories/simulation_repository.dart';
import '../controllers/simulation_controller.dart';

class SimulationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SimulationProvider(Get.find<ApiClient>()));
    Get.lazyPut(() => SimulationRepository(Get.find()));
    Get.lazyPut<SimulationController>(() => SimulationController(Get.find()));
  }
}
