import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../features/favorites/controllers/favorites_controller.dart';
import '../../../features/favorites/views/favorites_view.dart';
import '../../../features/profile/views/profile_view.dart';
import '../../../features/properties/views/properties_view.dart';
import '../../../features/search/views/search_view.dart';
import '../../../shared/widgets/app_nav_bar.dart';
import '../controllers/shell_controller.dart';

/// Root scaffold that hosts the bottom-nav tabs via [IndexedStack].
///
/// Tabs: Home · Search · [FAB] · Wishlist · Compte
class ShellView extends GetView<ShellController> {
  const ShellView({super.key});

  static const _pages = <Widget>[
    PropertiesView(),
    SearchView(),
    FavoritesView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: _pages,
        ),
      ),
      bottomNavigationBar: Obx(() {
        // Re-read favorites length so the badge updates reactively.
        final count = () {
          try {
            return Get.find<FavoritesController>().favorites.length;
          } catch (_) {
            return 0;
          }
        }();
        return AppNavBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.goTo,
          onFabTap: controller.onFabTap,
          wishlistCount: count,
        );
      }),
    );
  }
}
