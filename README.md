# DZ Immobilier — Mobile

Flutter mobile app for **[dz-immobilier.com](https://www.dz-immobilier.com)**, the Algerian
real‑estate marketplace (résidents + diaspora). It talks to an Odoo 17 backend over
JSON‑RPC and covers listings, AI property valuation, mortgage simulation, favorites
and a user account.

> Platforms: Android · iOS (Web target present but not the focus).

---

## Features

- **Listings** — home feed + **search with filters** (wilaya, type, price, surface, rooms).
- **Property detail** — image gallery, AI valuation, DZ reliability scores, per‑bank
  credit estimates, agency contact, wishlist, and a native **"Faire une offre"** form.
- **Estimation** — *Speed30* "estimate in 30 seconds" + a full multi‑step wizard.
- **Simulation** — 4‑step mortgage/credit simulator with conventional vs Mourabaha results.
- **Auth** — login · register · forgot password (Odoo session cookies).
- **Account** — profile, **language switch (FR / EN / AR + RTL)** and **light/dark theme**.

## Tech stack

| Concern | Choice |
|---|---|
| State / DI / routing | **GetX** (`get`) |
| Networking | `dio` + `dio_cookie_manager` + `cookie_jar` (Odoo session, **not** Bearer) |
| Local storage | `get_storage` |
| i18n | `flutter_localizations` + `gen-l10n` (ARB) |
| Images | `cached_network_image` |
| Misc | `intl`, `url_launcher`, `share_plus`, `connectivity_plus`, `flutter_svg` |

Architecture: **View → Controller → Repository → Provider → ApiClient** (GetX MVC),
with per‑route bindings.

## Project structure

```
lib/
├── main.dart                 # entry + permanent services (Storage, Connectivity, Api, Locale, Theme)
├── app/                      # constants, routes, theme tokens, bindings
├── core/                     # network (ApiClient), services, storage
├── data/                     # models · providers · repositories
├── features/                 # shell, properties, property_detail, search, favorites,
│                             # auth, profile, estimation, speed30, simulation
├── l10n/                     # ARB sources + generated localizations  (see lib/l10n/README.md)
└── shared/                   # reusable widgets, extensions, helpers
```

## Getting started

Requires the [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.10`).

```bash
flutter pub get
flutter gen-l10n        # generate localizations (also runs on `flutter run`)
flutter run             # run on a connected device / emulator
```

Common scripts:

```bash
flutter analyze         # static analysis (lints)
dart format lib/        # format
flutter test            # tests
flutter build apk --release --dart-define=DZ_BROWSE_LOGIN=... --dart-define=DZ_BROWSE_PASSWORD=...
flutter build ios --release --dart-define=DZ_BROWSE_LOGIN=... --dart-define=DZ_BROWSE_PASSWORD=...
```

## Configuration

- Backend base URL and endpoint paths live in
  [`lib/app/constants/api_constants.dart`](lib/app/constants/api_constants.dart).
- The app authenticates against Odoo and persists the **session cookie** (no JWT).

> **Security note:** a shared read‑only "browse" account lets guests read public
> listings (the backend has no public listings endpoint yet). The credentials are
> passed at build time via `--dart-define=DZ_BROWSE_LOGIN=...
> --dart-define=DZ_BROWSE_PASSWORD=...` (see `ApiConstants.browseLogin`) rather than
> committed to source. This only keeps them out of git history going forward — they
> are still compiled into the release binary and extractable from it. Replace this
> account with a least‑privilege one or a real public API before relying on it long
> term; see `docs/MISSING_ENDPOINTS.md` #2.

## Internationalization

Three locales — **Français (source) · English · العربية (RTL)**. To add or edit
strings, update the ARB files in `lib/l10n/arb/` and run `flutter gen-l10n`.
Full workflow: [`lib/l10n/README.md`](lib/l10n/README.md). Use strings via
`context.l10n.<key>`.

## Docs

- [`docs/MISSING_ENDPOINTS.md`](docs/MISSING_ENDPOINTS.md) — backend endpoint audit
  (what exists vs is missing on prod).
- [`lib/l10n/README.md`](lib/l10n/README.md) — localization guide.
