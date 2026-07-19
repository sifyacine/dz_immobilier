import '../../app/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/commune_model.dart';
import '../models/form_schema_model.dart';
import '../models/speed30_model.dart';
import '../models/valuation_category_model.dart';
import '../models/valuation_result_model.dart';
import '../models/wilaya_model.dart';

/// Data source for the estimation wizard.
class EstimationProvider {
  final ApiClient _api;
  EstimationProvider(this._api);

  /// Fetches the 58 Algerian wilayas from `/api/valuation/v1/wilayas`.
  Future<List<Wilaya>> fetchWilayas() async {
    final result = await _api.call(
      ApiConstants.valuationWilayas,
      params: {'lang': 'fr_FR'},
    );
    final list = result as List? ?? [];
    return list
        .map((e) => Wilaya.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetches communes for the given [wilayaId] from `/api/valuation/v1/communes`.
  Future<List<Commune>> fetchCommunes(int wilayaId) async {
    for (final paramKey in ['wilaya_id', 'state_id']) {
      final result = await _api.call(
        ApiConstants.valuationCommunes,
        params: {paramKey: wilayaId, 'lang': 'fr_FR'},
      );
      if (result == null) continue;

      List raw;
      if (result is List) {
        raw = result;
      } else if (result is Map) {
        raw = (result['communes'] ?? result['items'] ?? result.values.first)
            as List? ?? [];
      } else {
        continue;
      }

      if (raw.isNotEmpty) {
        return raw
            .map((e) => Commune.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }
    return [];
  }

  /// Fetches the dynamic form schema for a given [categoryId] from
  /// `/api/intelligence/v1/form_schema`.
  ///
  /// Returns sections keyed by name (construction, essential, financier, vue…),
  /// each containing a list of attributes with selectable values.
  Future<List<FormSchemaSection>> fetchFormSchema(int categoryId) async {
    final result = await _api.call(
      ApiConstants.intelligenceFormSchema,
      params: {'category_id': categoryId, 'lang': 'fr_FR'},
    );

    if (result is! Map) return [];
    final sections = result['sections'];
    if (sections is! Map) return [];

    return sections.entries.map((entry) {
      final key = entry.key as String;
      final attrs = (entry.value as List? ?? [])
          .map((a) =>
              FormSchemaAttribute.fromJson(a as Map<String, dynamic>))
          .toList();
      return FormSchemaSection(
        key: key,
        label: FormSchemaSection.labelFromKey(key),
        attributes: attrs,
      );
    }).toList();
  }

  /// Posts the owner's revised selling price after seeing the valuation report.
  Future<void> submitOwnerEstimateAfter(
      int valuationId, double amount) async {
    await _api.call(
      ApiConstants.valuationOwnerEstimateAfter,
      params: {
        'valuation_id': valuationId,
        'owner_estimate_after': amount,
      },
    );
  }

  /// Submits the completed estimation form to `/api/valuation/v1/submit`
  /// and returns the parsed valuation result.
  Future<ValuationResult> submitValuation(Map<String, dynamic> payload) async {
    final result = await _api.call(
      ApiConstants.valuationSubmit,
      params: payload,
    );
    if (result is! Map<String, dynamic>) {
      throw Exception('Réponse inattendue du serveur.');
    }
    return ValuationResult.fromJson(result);
  }

  /// Fetches the Speed30 curated categories (transactions + their property
  /// types) from `/api/valuation/v1/speed30_categories`.
  Future<List<Speed30Transaction>> fetchSpeed30Categories() async {
    final result = await _api.call(
      ApiConstants.valuationSpeed30Categories,
      params: {'lang': 'fr_FR'},
    );
    final list = result as List? ?? const [];
    return list
        .map((e) => Speed30Transaction.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Runs a Speed30 quick estimate (no persistence) via
  /// `/api/valuation/v1/quick_estimate`.
  Future<QuickEstimate> quickEstimate({
    required int wilayaId,
    int? communeId,
    required double surface,
    required int categoryId,
    required String transactionType, // 'sale' | 'rent'
    required String condition, // 'new' | 'good' | 'needs_renovation'
  }) async {
    final result = await _api.call(
      ApiConstants.valuationQuickEstimate,
      params: {
        'wilaya_id': wilayaId,
        'commune_id': ?communeId,
        'surface': surface,
        'category_id': categoryId,
        'transaction_type': transactionType,
        'condition': condition,
        'lang': 'fr_FR',
      },
    );
    if (result is! Map<String, dynamic>) {
      throw Exception('Réponse inattendue du serveur.');
    }
    return QuickEstimate.fromJson(result);
  }

  /// Fetches one level of the category tree from `/api/valuation/v1/categories`.
  ///
  /// - No [parentId] → returns top-level transaction types (Sale/Rent…).
  /// - With [parentId] → returns children of that category (property types
  ///   or sub-types depending on the level).
  Future<List<ValuationCategory>> fetchCategories({int? parentId}) async {
    final params = <String, dynamic>{'lang': 'fr_FR'};
    if (parentId != null) params['parent_id'] = parentId;

    final result = await _api.call(
      ApiConstants.valuationCategories,
      params: params,
    );

    if (result is List) {
      return result
          .map((e) => ValuationCategory.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
