import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/storage/storage_service.dart';
import '../../../data/models/property_model.dart';
import '../../../data/repositories/property_repository.dart';

/// Drives the Wishlist tab.
///
/// Backed by the real `product.wishlist` API (same endpoints
/// [PropertyDetailController] uses) — requires a logged-in user.
class FavoritesController extends GetxController {
  final PropertyRepository _repository;
  final StorageService _storage;
  FavoritesController(this._repository, this._storage);

  final RxList<Property> favorites = <Property>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString selectedFilter = 'Tous'.obs;

  /// variantId -> wishlist record id, for the current user.
  Map<int, int> _wishIds = {};

  @override
  void onInit() {
    super.onInit();
    if (_storage.isLoggedIn) load();
  }

  List<Property> get filteredFavorites {
    final filter = selectedFilter.value;
    if (filter == 'Tous') return favorites;
    final isRent = filter == 'À louer';
    return favorites.where((p) => p.isRent == isRent).toList();
  }

  bool isFavorite(int propertyId) =>
      favorites.any((p) => p.id == propertyId);

  Future<void> load() async {
    if (!_storage.isLoggedIn) {
      favorites.clear();
      _wishIds = {};
      return;
    }
    try {
      isLoading.value = true;
      error.value = '';
      final wishMap = await _repository.fetchWishlist();
      _wishIds = wishMap;
      favorites.value = wishMap.isEmpty
          ? []
          : await _repository.fetchWishlistProperties(wishMap.keys.toList());
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Adds/removes [property] from the real wishlist. Guests are prompted to
  /// log in first (mirrors `PropertyDetailController.toggleFavorite`).
  Future<void> toggle(Property property) async {
    if (!_storage.isLoggedIn) {
      _promptLogin();
      return;
    }
    if (property.variantId == 0) return;

    if (isFavorite(property.id)) {
      await remove(property);
      return;
    }

    favorites.add(property); // optimistic
    try {
      await _repository.addToWishlist(property.variantId);
      final wishMap = await _repository.fetchWishlist();
      _wishIds = wishMap;
    } catch (_) {
      favorites.removeWhere((p) => p.id == property.id); // revert
      _showError();
    }
  }

  Future<void> remove(Property property) async {
    final wishId = _wishIds[property.variantId];
    final prev = List<Property>.from(favorites);
    favorites.removeWhere((p) => p.id == property.id); // optimistic
    if (wishId == null) return;
    try {
      await _repository.removeFromWishlist(wishId);
      _wishIds.remove(property.variantId);
    } catch (_) {
      favorites.value = prev; // revert
      _showError();
    }
  }

  Future<void> clear() async {
    final prev = List<Property>.from(favorites);
    final wishIds = Map<int, int>.from(_wishIds);
    favorites.clear();
    try {
      await Future.wait(wishIds.values.map(_repository.removeFromWishlist));
      _wishIds.clear();
    } catch (_) {
      favorites.value = prev;
      _wishIds = wishIds;
      _showError();
    }
  }

  void _promptLogin() {
    Get.snackbar(
      'Connexion requise',
      'Connectez-vous pour sauvegarder vos favoris.',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      mainButton: TextButton(
        onPressed: () {
          if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
          Get.toNamed(Routes.login);
        },
        child: const Text('Se connecter'),
      ),
    );
  }

  void _showError() => Get.snackbar('Erreur', 'Action impossible. Réessayez.',
      snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
}
