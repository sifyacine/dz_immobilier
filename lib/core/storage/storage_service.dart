import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// App-wide local persistence (user, onboarding flag, theme).
/// Session cookies are managed separately by the cookie jar in [ApiClient].
/// Registered as a permanent [GetxService] in `main()` after async init.
class StorageService extends GetxService {
  late final GetStorage _box;

  static const String _kUser = 'user';
  static const String _kOnboardingSeen = 'onboarding_seen';
  static const String _kThemeMode = 'theme_mode';
  static const String _kLocale = 'app_locale';

  Future<StorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  // Logged-in state: true when a user object is stored locally.
  // The actual session validity is managed by the cookie jar.
  bool get isLoggedIn => user != null;

  // Cached user (stored after login, cleared on logout)
  Map<String, dynamic>? get user => _box.read<Map<String, dynamic>>(_kUser);
  set user(Map<String, dynamic>? value) =>
      value == null ? _box.remove(_kUser) : _box.write(_kUser, value);

  // Convenience accessors for the most common profile fields
  int get uid => user?['uid'] as int? ?? 0;
  int get partnerId => user?['partner_id'] as int? ?? 0;

  // Onboarding
  bool get onboardingSeen => _box.read<bool>(_kOnboardingSeen) ?? false;
  set onboardingSeen(bool value) => _box.write(_kOnboardingSeen, value);

  // Theme mode (system | light | dark)
  String? get themeMode => _box.read<String>(_kThemeMode);
  set themeMode(String? value) => _box.write(_kThemeMode, value);

  // Locale — ISO 639-1 language code ('fr', 'ar', 'en')
  String? get localeCode => _box.read<String>(_kLocale);
  set localeCode(String? value) =>
      value == null ? _box.remove(_kLocale) : _box.write(_kLocale, value);

  /// Wipe all local state (e.g. on logout). Call [ApiClient.clearSession]
  /// separately to also delete the session cookie.
  Future<void> clear() => _box.erase();
}
