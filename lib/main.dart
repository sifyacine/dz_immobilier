import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'app/bindings/initial_binding.dart';
import 'app/constants/app_constants.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';
import 'core/network/api_client.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/locale_service.dart';
import 'core/services/theme_service.dart';
import 'core/storage/storage_service.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Services must be ready before the first frame.
  await Get.putAsync<StorageService>(() => StorageService().init(),
      permanent: true);
  await Get.putAsync<ConnectivityService>(() => ConnectivityService().init(),
      permanent: true);
  // ApiClient needs path_provider (async) for the persistent cookie jar.
  await Get.putAsync<ApiClient>(() => ApiClient().init(), permanent: true);
  await Get.putAsync<LocaleService>(() => LocaleService().init(),
      permanent: true);
  await Get.putAsync<ThemeService>(() => ThemeService().init(),
      permanent: true);
  runApp(const DzImmobilierApp());
}

class DzImmobilierApp extends StatelessWidget {
  const DzImmobilierApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeService = Get.find<LocaleService>();
    final themeService = Get.find<ThemeService>();
    return Obx(
      () => GetMaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeService.themeMode,
        locale: localeService.locale,
        supportedLocales: LocaleService.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        initialBinding: InitialBinding(),
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
      ),
    );
  }
}
