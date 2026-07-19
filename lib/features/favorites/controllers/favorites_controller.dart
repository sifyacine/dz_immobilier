import 'package:get/get.dart';

import '../../../data/models/property_model.dart';

/// Drives the Wishlist tab.
///
/// Keeps an in-memory list that any screen can mutate via [toggle].
/// Persistence / API sync will be added in a future iteration.
class FavoritesController extends GetxController {
  final RxList<Property> favorites = <Property>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedFilter = 'Tous'.obs;

  List<Property> get filteredFavorites {
    final filter = selectedFilter.value;
    if (filter == 'Tous') return favorites;
    final isRent = filter == 'À louer';
    return favorites.where((p) => p.isRent == isRent).toList();
  }

  bool isFavorite(int propertyId) =>
      favorites.any((p) => p.id == propertyId);

  void toggle(Property property) {
    if (isFavorite(property.id)) {
      favorites.removeWhere((p) => p.id == property.id);
    } else {
      favorites.add(property);
    }
  }

  void remove(Property property) =>
      favorites.removeWhere((p) => p.id == property.id);

  void clear() => favorites.clear();
}
