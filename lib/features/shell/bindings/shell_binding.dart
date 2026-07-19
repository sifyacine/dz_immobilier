import 'package:get/get.dart';

import '../../favorites/bindings/favorites_binding.dart';
import '../../profile/bindings/profile_binding.dart';
import '../../properties/bindings/properties_binding.dart';
import '../../search/bindings/search_binding.dart';
import '../controllers/shell_controller.dart';

class ShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShellController>(() => ShellController());
    // Bootstrap the initial tab's dependencies.
    PropertiesBinding().dependencies();
    // Bootstrap wishlist so badge count is reactive from launch.
    FavoritesBinding().dependencies();
    // Bootstrap search feature.
    SearchBinding().dependencies();
    // Bootstrap profile tab (loads logged-in user details).
    ProfileBinding().dependencies();
  }
}
