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

  void goTo(int index) {
    currentIndex.value = index;
    // Wishlist tab (index 2) — reload from the server on every visit so it
    // reflects favorites toggled elsewhere (e.g. the property detail screen)
    // and picks up login/logout state changes.
    if (index == 2) {
      try {
        Get.find<FavoritesController>().load();
      } catch (_) {}
    }
  }

  void onFabTap() => Get.toNamed(Routes.simulation);
}
