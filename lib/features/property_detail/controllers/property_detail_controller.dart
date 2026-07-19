import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/constants/api_constants.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/storage/storage_service.dart';
import '../../../data/models/property_detail_model.dart';
import '../../../data/models/property_model.dart';
import '../../../data/repositories/property_repository.dart';
import '../widgets/offer_sheet.dart';

/// Loads a single listing and drives the detail screen's actions.
class PropertyDetailController extends GetxController {
  final PropertyRepository _repository;
  final StorageService _storage;
  PropertyDetailController(this._repository, this._storage);

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final Rxn<PropertyDetail> detail = Rxn<PropertyDetail>();
  final RxInt carouselIndex = 0.obs;
  final RxBool isFavorite = false.obs;

  int _id = 0;
  int? _wishId; // product.wishlist record id when favorited

  bool get isLoggedIn => _storage.isLoggedIn;

  /// Optional list item passed on navigation, used to paint the header
  /// instantly while the full record loads.
  Property? seed;

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is Property) {
      seed = arg;
      _id = arg.id;
    } else if (arg is int) {
      _id = arg;
    } else if (arg is Map && arg['id'] is int) {
      _id = arg['id'] as int;
    }
    load();
  }

  Future<void> load() async {
    if (_id == 0) {
      error.value = 'Annonce introuvable.';
      return;
    }
    try {
      isLoading.value = true;
      error.value = '';
      detail.value = await _repository.getProperty(_id);
      await _syncWishlist();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Reflects whether this listing is already in the logged-in user's wishlist.
  Future<void> _syncWishlist() async {
    final d = detail.value;
    if (d == null || !isLoggedIn || d.variantId == 0) return;
    try {
      final map = await _repository.fetchWishlist();
      _wishId = map[d.variantId];
      isFavorite.value = _wishId != null;
    } catch (_) {
      // Non-fatal — leave the heart in its current state.
    }
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  /// Wishlist is reserved for signed-in users (mirrors the website). Guests are
  /// prompted to log in; signed-in users toggle via `/shop/wishlist/*`.
  Future<void> toggleFavorite() async {
    if (!isLoggedIn) {
      _promptLogin();
      return;
    }
    final d = detail.value;
    if (d == null || d.variantId == 0) return;

    final wasFavorite = isFavorite.value;
    isFavorite.value = !wasFavorite; // optimistic
    try {
      if (wasFavorite) {
        if (_wishId != null) await _repository.removeFromWishlist(_wishId!);
        _wishId = null;
      } else {
        await _repository.addToWishlist(d.variantId);
        await _syncWishlist(); // resolve the new wishlist record id
      }
    } catch (_) {
      isFavorite.value = wasFavorite; // revert on failure
      Get.snackbar('Erreur', 'Action impossible. Réessayez.',
          snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
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

  /// Opens the native share sheet with the listing link (which unfurls into a
  /// rich preview via the website's Open Graph tags).
  Future<void> share() async {
    final d = detail.value;
    final url = _listingUrl();
    final text = d != null && d.title.isNotEmpty ? '${d.title}\n$url' : url;
    await SharePlus.instance.share(ShareParams(text: text, subject: d?.title));
  }

  void openComparator() => Get.toNamed(Routes.simulation);

  Future<void> call() => _launch('tel:${_phone.replaceAll(' ', '')}');

  Future<void> whatsapp() {
    final digits = _phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return Future.value();
    return _launch('https://wa.me/$digits');
  }

  Future<void> emailAgent() {
    final mail = detail.value?.agentEmail ?? '';
    if (mail.isEmpty) return Future.value();
    return _launch('mailto:$mail');
  }

  /// Opens the "Faire une offre" bottom-sheet form.
  void makeOffer() {
    final d = detail.value;
    if (d == null) return;
    Get.bottomSheet(
      OfferSheet(detail: d, controller: this),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  /// Submits a price offer (`POST /dz/listing/offer-request`). Throws on
  /// failure so the sheet can keep the form open and surface the message.
  Future<void> submitOffer({
    required num amount,
    required String financing,
    required String name,
    required String phone,
    String email = '',
    String message = '',
  }) async {
    final d = detail.value;
    if (d == null) return;
    await _repository.submitOffer(
      productTemplateId: d.id,
      amount: amount,
      financing: financing,
      name: name,
      phone: phone,
      email: email,
      message: message,
    );
  }

  String get _phone {
    final d = detail.value;
    if (d == null) return '';
    return d.agentMobile.isNotEmpty ? d.agentMobile : d.agentPhone;
  }

  String _listingUrl() {
    final d = detail.value;
    final path = d?.websiteUrl ?? '';
    return path.isNotEmpty ? '${ApiConstants.baseUrl}$path' : ApiConstants.baseUrl;
  }

  Future<void> _launch(String uri) async {
    final ok = await launchUrl(
      Uri.parse(uri),
      mode: LaunchMode.externalApplication,
    );
    if (!ok) {
      Get.snackbar('Erreur', 'Action impossible sur cet appareil.',
          snackPosition: SnackPosition.TOP);
    }
  }
}
