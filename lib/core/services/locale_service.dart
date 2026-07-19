import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../storage/storage_service.dart';

class LocaleService extends GetxService {
  static const supportedLocales = [
    Locale('fr'),
    Locale('ar'),
    Locale('en'),
  ];

  static const localeLabels = {
    'fr': 'Français',
    'ar': 'عربي',
    'en': 'English',
  };

  late final Rx<Locale> _locale;

  Locale get locale => _locale.value;

  Future<LocaleService> init() async {
    final storage = Get.find<StorageService>();
    final saved = storage.localeCode;
    _locale = Rx<Locale>(
      saved != null ? Locale(saved) : const Locale('fr'),
    );
    return this;
  }

  Future<void> setLocale(Locale locale) async {
    _locale.value = locale;
    Get.find<StorageService>().localeCode = locale.languageCode;
    await Get.updateLocale(locale);
  }
}
