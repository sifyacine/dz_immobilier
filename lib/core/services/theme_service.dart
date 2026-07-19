import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../storage/storage_service.dart';

/// Reactive light/dark/system theme, persisted in [StorageService].
/// Registered as a permanent service in `main()`; `GetMaterialApp.themeMode`
/// binds to [themeMode] via an `Obx`, so changes apply app-wide instantly.
class ThemeService extends GetxService {
  late final Rx<ThemeMode> _mode;

  ThemeMode get themeMode => _mode.value;

  Future<ThemeService> init() async {
    final saved = Get.find<StorageService>().themeMode;
    _mode = Rx<ThemeMode>(_parse(saved));
    return this;
  }

  void setMode(ThemeMode mode) {
    _mode.value = mode;
    Get.find<StorageService>().themeMode = _name(mode);
  }

  /// French label for the current mode (for the profile row).
  String get label => labelFor(_mode.value);

  static String labelFor(ThemeMode mode) => switch (mode) {
        ThemeMode.light => 'Clair',
        ThemeMode.dark => 'Sombre',
        ThemeMode.system => 'Système',
      };

  static ThemeMode _parse(String? value) => switch (value) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  static String _name(ThemeMode mode) => switch (mode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      };
}
