import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:get/get.dart' hide Response;
import 'package:path_provider/path_provider.dart';

import '../../app/constants/api_constants.dart';
import '../storage/storage_service.dart';
import 'api_exceptions.dart';

/// Single HTTP entry point for the app.
///
/// Uses Odoo session cookies (not Bearer tokens). All custom DZ-Immobilier
/// endpoints use the JSON-RPC 2.0 envelope — call [call] for those.
/// Standard Odoo ORM goes through [callKw].
class ApiClient extends GetxService {
  late final Dio _dio;
  late final PersistCookieJar _cookieJar;

  Future<ApiClient> init() async {
    final dir = await getApplicationSupportDirectory();
    _cookieJar = PersistCookieJar(
      storage: FileStorage('${dir.path}${Platform.pathSeparator}.cookies${Platform.pathSeparator}'),
    );

    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          // Required by Odoo to pass CSRF check on JSON controllers
          'X-Requested-With': 'XMLHttpRequest',
        },
      ),
    );

    _dio.interceptors.add(CookieManager(_cookieJar));

    assert(() {
      _dio.interceptors
          .add(LogInterceptor(requestBody: true, responseBody: true));
      return true;
    }());

    return this;
  }

  /// Wraps [endpoint] in the Odoo JSON-RPC 2.0 envelope and returns the
  /// unwrapped `result`. Throws [ApiException] on JSON-RPC errors or HTTP
  /// errors.
  ///
  /// Passes [params] as-is. Auth endpoints (/web/session/authenticate,
  /// /web/signup, etc.) must NOT receive extra keys — Odoo raises a TypeError
  /// on unexpected kwargs. Use [callKw] for ORM calls that need a lang context.
  Future<dynamic> call(
    String endpoint, {
    Map<String, dynamic>? params,
    bool isRetry = false,
  }) async {
    final body = {
      'jsonrpc': '2.0',
      'method': 'call',
      'params': params ?? {},
    };

    try {
      final response = await _dio.post(endpoint, data: body);
      final data = response.data;

      if (data is Map<String, dynamic> && data.containsKey('error')) {
        final odooError = data['error'] as Map<String, dynamic>;
        // The ORM requires an authenticated session. When the session is
        // missing/stale, sign in with the shared browse account and retry
        // once — but only for guests. A logged-in user whose session expired
        // should re-authenticate, not be silently downgraded to browsing.
        if (!isRetry && _isSessionExpired(odooError)) {
          if (_shouldBrowseLogin()) {
            await _bootstrapPublicSession();
            return call(endpoint, params: params, isRetry: true);
          }
          throw ApiException('Session expirée. Reconnectez-vous.',
              statusCode: 401);
        }
        throw ApiException.fromOdooError(odooError);
      }

      if (data is Map<String, dynamic>) {
        return data['result'];
      }
      return data;
    } on ApiException {
      rethrow;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// True when no real user is logged in, so an expired/absent session should
  /// fall back to the shared browse account rather than forcing a re-login.
  bool _shouldBrowseLogin() {
    if (!Get.isRegistered<StorageService>()) return true;
    return !Get.find<StorageService>().isLoggedIn;
  }

  // De-dupes concurrent browse logins (e.g. parallel search_count +
  // search_read on the home feed both hitting an expired session at once).
  Future<void>? _browseLoginInFlight;

  /// Signs in with the shared read-only browse account so anonymous users can
  /// read public listings via the ORM. Concurrent callers share one login.
  Future<void> _bootstrapPublicSession() {
    return _browseLoginInFlight ??=
        _loginBrowseAccount().whenComplete(() => _browseLoginInFlight = null);
  }

  Future<void> _loginBrowseAccount() async {
    await _cookieJar.deleteAll();
    try {
      await _dio.post(
        ApiConstants.login,
        data: {
          'jsonrpc': '2.0',
          'method': 'call',
          'params': {
            'db': ApiConstants.db,
            'login': ApiConstants.browseLogin,
            'password': ApiConstants.browsePassword,
          },
        },
      );
    } catch (_) {
      // Swallow — the retried call will surface a meaningful error if the
      // session is still unusable.
    }
  }

  static bool _isSessionExpired(Map<String, dynamic> error) {
    final d = error['data'];
    if (d is Map<String, dynamic>) {
      final name = d['name'] as String? ?? '';
      return name.contains('SessionExpiredException');
    }
    return false;
  }

  /// Convenience wrapper for `/web/dataset/call_kw` (Odoo ORM access).
  ///
  /// Injects `context.lang` into kwargs so ORM returns French field labels.
  /// Caller-supplied `context` keys are merged on top.
  Future<dynamic> callKw({
    required String model,
    required String method,
    List<dynamic> args = const [],
    Map<String, dynamic> kwargs = const {},
    String lang = 'fr_FR',
  }) {
    final mergedContext = <String, dynamic>{'lang': lang};
    if (kwargs['context'] is Map) {
      mergedContext.addAll(kwargs['context'] as Map<String, dynamic>);
    }
    final mergedKwargs = Map<String, dynamic>.from(kwargs)
      ..['context'] = mergedContext
      ..remove('lang'); // lang belongs inside context, not at kwargs root

    return call(
      ApiConstants.callKw,
      params: {
        'model': model,
        'method': method,
        'args': args,
        'kwargs': mergedKwargs,
      },
    );
  }

  /// Posts a plain JSON body (no JSON-RPC envelope) and returns the parsed
  /// response. Used for custom DZ-Immobilier REST-style controllers such as
  /// `/api/marketplace/v1/search`.
  Future<dynamic> postRaw(
    String endpoint, {
    Map<String, dynamic> body = const {},
  }) async {
    try {
      final response = await _dio.post(endpoint, data: body);
      final data = response.data;
      // Surface Odoo-style error objects even from plain endpoints
      if (data is Map<String, dynamic> && data.containsKey('error')) {
        throw ApiException.fromOdooError(
            data['error'] as Map<String, dynamic>);
      }
      return data;
    } on ApiException {
      rethrow;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Deletes all stored session cookies (call after /web/session/destroy).
  Future<void> clearSession() => _cookieJar.deleteAll();
}
