/// Form-field validators returning a localized error string, or `null` when
/// valid — ready to drop into `TextFormField.validator`.
class Validators {
  Validators._();

  // Each validator accepts optional localized messages; the French strings are
  // kept as fallbacks so the functions still work without a BuildContext.

  static String? requiredField(String? value,
      {String field = 'Ce champ', String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? '$field est requis';
    }
    return null;
  }

  static String? email(String? value, {String? requiredMsg, String? invalidMsg}) {
    if (value == null || value.isEmpty) return requiredMsg ?? 'Email requis';
    final re = RegExp(r'^[\w.\-]+@([\w\-]+\.)+[\w\-]{2,}$');
    return re.hasMatch(value) ? null : (invalidMsg ?? 'Email invalide');
  }

  static String? password(String? value, {String? requiredMsg, String? minMsg}) {
    if (value == null || value.isEmpty) {
      return requiredMsg ?? 'Mot de passe requis';
    }
    if (value.length < 8) return minMsg ?? 'Au moins 8 caractères';
    return null;
  }

  /// Algerian mobile format: 0[5|6|7] followed by 8 digits.
  static String? phone(String? value, {String? requiredMsg, String? invalidMsg}) {
    if (value == null || value.isEmpty) return requiredMsg ?? 'Téléphone requis';
    final re = RegExp(r'^0(5|6|7)[0-9]{8}$');
    return re.hasMatch(value) ? null : (invalidMsg ?? 'Numéro invalide');
  }
}
