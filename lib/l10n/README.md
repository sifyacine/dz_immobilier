# Internationalization (i18n) — ready to translate

The app is wired for **3 languages**: **Français (default/source)**, **English**,
and **العربية (Arabic, RTL)**. Everything below is already set up — to localize a
screen you only replace its hardcoded strings with `context.l10n.<key>`.

## How it works

| Piece | Location |
|---|---|
| Source / template strings | `lib/l10n/arb/app_fr.arb` (French is the source of truth) |
| Translations | `lib/l10n/arb/app_en.arb`, `lib/l10n/arb/app_ar.arb` |
| Generator config | `l10n.yaml` (project root) |
| Generated code | `lib/l10n/app_localizations*.dart` (do **not** edit by hand) |
| Access helper | `lib/shared/extensions/l10n_extension.dart` → `context.l10n` / `Get.l10n` |
| App wiring | `main.dart` (delegates + `supportedLocales`) |
| Language switch UI | Profile → **Langue** (persisted by `LocaleService`) |
| RTL | Automatic for Arabic via `GlobalWidgetsLocalizations` |

## Using a string in a widget

```dart
import 'package:dz_immobilier/shared/extensions/l10n_extension.dart';

Text(context.l10n.navHome);          // inside a widget with a BuildContext
Get.snackbar(Get.l10n.commonError, …); // in controllers / no-context places
```

A live example: the bottom navigation labels (`lib/shared/widgets/app_nav_bar.dart`)
use `context.l10n.navHome/navSearch/navFavorites/navAccount`.

## Adding a new string

1. Add the key to **`app_fr.arb`** (with an `@key` description; declare any
   placeholders/plurals there — see `commonItemCount` / `commonWelcome`).
2. Add the same key to **`app_en.arb`** and **`app_ar.arb`** with the translation.
3. Regenerate: `flutter gen-l10n` (also runs automatically on `flutter run`).
4. Use it via `context.l10n.<key>`.

> Keep keys grouped by feature prefix: `common*`, `nav*`, `auth*`, `properties*`,
> `propertyDetail*`, `search*`, `favorites*`, `profile*`, `estimation*`,
> `simulation*`, `settings*`.

## Migration status

The pipeline + all 3 ARB files are complete (~90 keys each). Screens are being
migrated from hardcoded French to `context.l10n` incrementally — the bottom nav
is done; remaining screens just need their `'...'` literals swapped for keys
(the keys already exist for most visible strings).

## Notes

- French is the fallback: any key missing from `app_en`/`app_ar` falls back to French.
- Don't hardcode user-facing strings in new code — add a key instead.
- Currency/number formatting stays via `intl` (`NumberFormat`), independent of the locale toggle.
</content>
