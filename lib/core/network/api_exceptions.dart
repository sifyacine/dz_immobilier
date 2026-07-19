import 'package:dio/dio.dart';

/// Normalised error type the rest of the app depends on, so controllers and
/// views never touch Dio internals or Odoo error envelopes directly.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;

  /// Parse the JSON-RPC `error` object returned by Odoo:
  /// `{"code": 200, "message": "...", "data": {"message": "...", ...}}`
  factory ApiException.fromOdooError(Map<String, dynamic> error) {
    final data = error['data'];
    String? msg;
    if (data is Map<String, dynamic>) {
      msg = data['message'] as String?;
    }
    return ApiException(
      msg ?? error['message'] as String? ?? 'Erreur serveur.',
    );
  }

  factory ApiException.fromDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException('La connexion a expiré. Réessayez.');
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode;
        final data = error.response?.data;
        // Try Odoo JSON-RPC error format first
        if (data is Map<String, dynamic> && data.containsKey('error')) {
          return ApiException.fromOdooError(
              data['error'] as Map<String, dynamic>);
        }
        final serverMsg =
            data is Map<String, dynamic> ? data['message'] as String? : null;
        return ApiException(serverMsg ?? _messageForStatus(code),
            statusCode: code);
      case DioExceptionType.cancel:
        return ApiException('Requête annulée.');
      case DioExceptionType.connectionError:
        return ApiException('Pas de connexion internet.');
      default:
        return ApiException('Une erreur est survenue. Réessayez.');
    }
  }

  static String _messageForStatus(int? code) {
    switch (code) {
      case 400:
        return 'Requête invalide.';
      case 401:
        return 'Session expirée. Reconnectez-vous.';
      case 403:
        return "Vous n'avez pas l'autorisation.";
      case 404:
        return 'Introuvable.';
      case 500:
        return 'Erreur serveur. Réessayez plus tard.';
      default:
        return 'Erreur inattendue (${code ?? 'inconnue'}).';
    }
  }
}
