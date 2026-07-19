import '../models/user_model.dart';
import '../providers/auth_provider.dart';

/// Business-facing access point for auth operations.
/// Controllers depend on this, not on [AuthProvider] directly.
class AuthRepository {
  final AuthProvider _provider;
  AuthRepository(this._provider);

  Future<User> login({
    required String email,
    required String password,
  }) => _provider.login(email: email, password: password);

  Future<User> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) => _provider.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );

  Future<void> forgotPassword({required String email}) =>
      _provider.forgotPassword(email: email);

  Future<void> logout() => _provider.logout();
}
