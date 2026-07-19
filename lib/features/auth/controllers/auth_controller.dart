import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/storage/storage_service.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../shared/extensions/l10n_extension.dart';

/// Drives all three auth screens: Login · Sign Up · Forgot Password.
class AuthController extends GetxController {
  final AuthRepository _repository;
  AuthController(this._repository);

  // ── Shared reactive state ──────────────────────────────────────────────────
  final isLoading = false.obs;

  // Password visibility toggles
  final obscurePassword = true.obs;
  final obscureConfirm = true.obs;

  // Forgot-password success flag
  final emailSent = false.obs;

  // ── Login ──────────────────────────────────────────────────────────────────
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      final user = await _repository.login(email: email, password: password);
      Get.find<StorageService>().user = user.toJson();
      Get.offAllNamed(Routes.shell);
    } catch (e) {
      _showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ── Register ───────────────────────────────────────────────────────────────
  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      final user = await _repository.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      Get.find<StorageService>().user = user.toJson();
      Get.offAllNamed(Routes.shell);
    } catch (e) {
      _showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ── Forgot password ────────────────────────────────────────────────────────
  Future<void> forgotPassword({required String email}) async {
    try {
      isLoading.value = true;
      await _repository.forgotPassword(email: email);
      emailSent.value = true;
    } catch (e) {
      _showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  void goToLogin() => Get.toNamed(Routes.login);
  void goToRegister() => Get.toNamed(Routes.register);
  void goToForgotPassword() => Get.toNamed(Routes.forgotPassword);

  void _showError(String message) {
    Get.snackbar(
      Get.l10n.commonErrorTitle,
      message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }
}
