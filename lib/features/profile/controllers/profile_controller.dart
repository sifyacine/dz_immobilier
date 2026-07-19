import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/services/locale_service.dart';
import '../../../core/services/theme_service.dart';
import '../../../core/storage/storage_service.dart';
import '../../../shared/widgets/option_picker_sheet.dart';

/// Drives the profile tab: loads the logged-in user's real `res.partner`
/// details and handles the web-only "become an agency" deep link.
class ProfileController extends GetxController {
  final ApiClient _api;
  final StorageService _storage;
  ProfileController(this._api, this._storage);

  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString phone = ''.obs;
  final RxString city = ''.obs;
  final RxString memberSince = ''.obs;
  final RxBool isLoading = false.obs;

  bool get isLoggedIn => _storage.isLoggedIn;

  String get initial => name.value.isNotEmpty ? name.value[0].toUpperCase() : '?';

  @override
  void onInit() {
    super.onInit();
    // Seed instantly from the cached login payload, then refresh from the ORM.
    final user = _storage.user;
    if (user != null) {
      name.value = (user['name'] as String?) ?? '';
      email.value = (user['email'] as String?) ?? '';
    }
    if (isLoggedIn) loadPartner();
  }

  /// Reads the current partner record for fresh name/contact + member-since.
  Future<void> loadPartner() async {
    final partnerId = _storage.partnerId;
    if (partnerId == 0) return;
    try {
      isLoading.value = true;
      final result = await _api.callKw(
        model: 'res.partner',
        method: 'read',
        args: [
          [partnerId],
          ['name', 'email', 'phone', 'mobile', 'city', 'create_date'],
        ],
      );
      if (result is List && result.isNotEmpty) {
        final p = result.first as Map<String, dynamic>;
        if (p['name'] is String) name.value = p['name'] as String;
        if (p['email'] is String) email.value = p['email'] as String;
        phone.value = _firstNonEmpty([p['phone'], p['mobile']]);
        if (p['city'] is String) city.value = p['city'] as String;
        memberSince.value = _formatMemberSince(p['create_date']);
      }
    } catch (_) {
      // Non-fatal — keep the cached login values.
    } finally {
      isLoading.value = false;
    }
  }

  // ── Preferences ────────────────────────────────────────────────────────────

  /// Current language label, reactive (read inside an Obx to auto-update).
  String get languageLabel =>
      LocaleService.localeLabels[Get.find<LocaleService>().locale.languageCode] ??
      'Français';

  /// Current theme label, reactive.
  String get themeLabel => Get.find<ThemeService>().label;

  void changeLanguage() {
    final service = Get.find<LocaleService>();
    Get.bottomSheet(
      OptionPickerSheet<String>(
        title: 'Langue',
        selected: service.locale.languageCode,
        options: [
          for (final l in LocaleService.supportedLocales)
            PickerOption(l.languageCode,
                LocaleService.localeLabels[l.languageCode] ?? l.languageCode),
        ],
        onSelected: (code) {
          Get.back();
          service.setLocale(Locale(code));
        },
      ),
      backgroundColor: Colors.transparent,
    );
  }

  void changeTheme() {
    final service = Get.find<ThemeService>();
    Get.bottomSheet(
      OptionPickerSheet<ThemeMode>(
        title: 'Apparence',
        selected: service.themeMode,
        options: const [
          PickerOption(ThemeMode.light, 'Clair', icon: Icons.light_mode_outlined),
          PickerOption(ThemeMode.dark, 'Sombre', icon: Icons.dark_mode_outlined),
          PickerOption(ThemeMode.system, 'Système',
              icon: Icons.brightness_auto_outlined),
        ],
        onSelected: (mode) {
          Get.back();
          service.setMode(mode);
        },
      ),
      backgroundColor: Colors.transparent,
    );
  }

  /// Opens the multi-step agency registration wizard in the browser.
  /// (Native agency onboarding is a Phase-2 item.)
  Future<void> openAgencySignup() async {
    final uri = Uri.parse(ApiConstants.agencySignupUrl);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) {
      Get.snackbar(
        'Erreur',
        "Impossible d'ouvrir la page d'inscription agence.",
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  static String _firstNonEmpty(List<dynamic> values) {
    for (final v in values) {
      if (v is String && v.isNotEmpty) return v;
    }
    return '';
  }

  static String _formatMemberSince(dynamic createDate) {
    if (createDate is! String) return '';
    final dt = DateTime.tryParse(createDate);
    if (dt == null) return '';
    const months = [
      'janv.', 'févr.', 'mars', 'avr.', 'mai', 'juin',
      'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.',
    ];
    return 'Membre depuis ${months[dt.month - 1]} ${dt.year}';
  }
}
