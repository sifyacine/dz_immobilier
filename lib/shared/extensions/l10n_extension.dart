import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../l10n/app_localizations.dart';

extension L10nBuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension L10nGetX on GetInterface {
  AppLocalizations get l10n => AppLocalizations.of(Get.context!);
}
