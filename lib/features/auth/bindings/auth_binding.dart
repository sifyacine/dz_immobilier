import 'package:get/get.dart';

import '../../../core/network/api_client.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/repositories/auth_repository.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthProvider>(() => AuthProvider(Get.find<ApiClient>()));
    Get.lazyPut<AuthRepository>(
        () => AuthRepository(Get.find<AuthProvider>()));
    Get.lazyPut<AuthController>(
        () => AuthController(Get.find<AuthRepository>()));
  }
}
