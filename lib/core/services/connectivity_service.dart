import 'dart:async';
import 'dart:io' show SocketException, InternetAddress;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

/// Tracks network + internet availability app-wide.
///
/// `connectivity_plus` only reports whether the device is *attached* to a
/// network (wifi/mobile), not whether the internet is actually reachable — so
/// [hasInternet] also performs a real host lookup to confirm.
///
/// Registered as a permanent service in `main()`. Read [isOnline] reactively
/// in an `Obx`, or call [hasInternet] for a one-shot check (e.g. before an
/// API call):
///
/// ```dart
/// if (!await Get.find<ConnectivityService>().hasInternet()) {
///   Get.snackbar('Hors ligne', 'Vérifiez votre connexion internet');
///   return;
/// }
/// ```
class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// Reactive online state: device is on a network *and* the internet responds.
  final RxBool isOnline = true.obs;

  Future<ConnectivityService> init() async {
    isOnline.value = await _resolve(await _connectivity.checkConnectivity());
    _subscription = _connectivity.onConnectivityChanged.listen((results) async {
      isOnline.value = await _resolve(results);
    });
    return this;
  }

  Future<bool> _resolve(List<ConnectivityResult> results) async {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return false;
    }
    return hasInternet();
  }

  /// Whether the device is attached to any network (does not guarantee the
  /// internet is reachable).
  Future<bool> hasNetwork() async {
    final results = await _connectivity.checkConnectivity();
    return results.isNotEmpty && !results.contains(ConnectivityResult.none);
  }

  /// True only when a real host is reachable — the dependable "is the internet
  /// actually working?" check.
  Future<bool> hasInternet() async {
    if (!await hasNetwork()) return false;
    if (kIsWeb) return true; // Socket lookup is unsupported on web
    try {
      final lookup = await InternetAddress.lookup('one.one.one.one')
          .timeout(const Duration(seconds: 4));
      return lookup.isNotEmpty && lookup.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
