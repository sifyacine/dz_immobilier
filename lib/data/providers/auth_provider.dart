import '../../app/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exceptions.dart';
import '../models/user_model.dart';

/// Remote data source for authentication against the Odoo backend.
///
/// All endpoints use the JSON-RPC 2.0 envelope via [ApiClient.call].
/// Session is managed transparently by the cookie jar in [ApiClient].
class AuthProvider {
  final ApiClient _api;
  AuthProvider(this._api);

  /// Authenticates the user against `/web/session/authenticate`.
  /// Throws [ApiException] with a French message on failure.
  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _api.call(
        ApiConstants.login,
        params: {
          'db': ApiConstants.db,
          'login': email,
          'password': password,
        },
      );

      final map = result as Map<String, dynamic>?;
      if (map == null || map['uid'] == false || map['uid'] == null) {
        throw ApiException('Email ou mot de passe incorrect.');
      }

      return User.fromOdooLogin(map);
    } on ApiException catch (e) {
      // Odoo returns a raw English "Access Denied" on bad credentials.
      if (_isInvalidCredentials(e.message)) {
        throw ApiException('Email ou mot de passe incorrect.');
      }
      rethrow;
    }
  }

  static bool _isInvalidCredentials(String message) {
    final m = message.toLowerCase();
    return m.contains('access denied') || m.contains('accessdenied');
  }

  /// Creates an account via `/web/signup`, then authenticates immediately.
  /// Throws [ApiException] on validation errors returned by Odoo.
  Future<User> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    int countryId = 62, // Algeria
  }) async {
    final result = await _api.call(
      ApiConstants.signup,
      params: {
        'name': name,
        'login': email,
        'password': password,
        'confirm_password': password, // already validated in the form
        'phone': phone,
        'country_id': countryId,
        'lang': 'fr_FR',
      },
    );

    // Odoo may return signup errors in the result object (not as JSON-RPC error)
    if (result is Map<String, dynamic> && result.containsKey('error')) {
      final msg = (result['error'] as Map<String, dynamic>?)?['message']
              as String? ??
          "Erreur lors de l'inscription.";
      throw ApiException(msg);
    }

    // Signup succeeded → authenticate to obtain a session cookie
    return login(email: email, password: password);
  }

  /// Sends a password-reset email via `/web/reset_password`.
  Future<void> forgotPassword({required String email}) async {
    await _api.call(
      ApiConstants.resetPassword,
      params: {'login': email},
    );
  }

  /// Destroys the Odoo session and clears local cookies.
  Future<void> logout() async {
    try {
      await _api.call(ApiConstants.logout, params: {});
    } catch (_) {
      // Best-effort — clear cookies regardless of server response.
    }
    await _api.clearSession();
  }
}
