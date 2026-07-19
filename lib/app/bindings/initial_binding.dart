import 'package:get/get.dart';

/// Registered once at startup via `GetMaterialApp.initialBinding`.
/// [ApiClient], [StorageService], and [ConnectivityService] are registered
/// earlier in `main()` because they need async initialisation before the
/// first frame.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Future app-wide singletons that don't need async init go here.
  }
}
