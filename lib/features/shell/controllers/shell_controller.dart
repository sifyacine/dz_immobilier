import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../favorites/controllers/favorites_controller.dart';

class ShellController extends GetxController {
  final currentIndex = 0.obs;

  // Live badge count from FavoritesController.
  int get wishlistCount {
    try {
      return Get.find<FavoritesController>().favorites.length;
    } catch (_) {
      return 0;
    }
  }

  void goTo(int index) => currentIndex.value = index;

  void onFabTap() => Get.toNamed(Routes.simulation);
}
