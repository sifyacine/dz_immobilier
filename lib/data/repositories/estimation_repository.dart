import '../models/commune_model.dart';
import '../models/form_schema_model.dart';
import '../models/speed30_model.dart';
import '../models/valuation_category_model.dart';
import '../models/valuation_result_model.dart';
import '../models/wilaya_model.dart';
import '../providers/estimation_provider.dart';

/// Business-facing access point for estimation wizard data.
class EstimationRepository {
  final EstimationProvider _provider;
  EstimationRepository(this._provider);

  Future<List<Wilaya>> fetchWilayas() => _provider.fetchWilayas();

  Future<List<Commune>> fetchCommunes(int wilayaId) =>
      _provider.fetchCommunes(wilayaId);

  /// Top-level categories (transaction types: Sale / Rent …).
  Future<List<ValuationCategory>> fetchTransactionTypes() =>
      _provider.fetchCategories();

  /// Property types for a selected transaction, or sub-types for a selected
  /// property type — same endpoint, different [parentId].
  Future<List<ValuationCategory>> fetchChildren(int parentId) =>
      _provider.fetchCategories(parentId: parentId);

  /// Dynamic form schema sections for the most-specific selected category.
  Future<List<FormSchemaSection>> fetchFormSchema(int categoryId) =>
      _provider.fetchFormSchema(categoryId);

  /// Speed30 curated categories (transactions + property types).
  Future<List<Speed30Transaction>> fetchSpeed30Categories() =>
      _provider.fetchSpeed30Categories();

  /// Speed30 quick estimate (no persistence).
  Future<QuickEstimate> quickEstimate({
    required int wilayaId,
    int? communeId,
    required double surface,
    required int categoryId,
    required String transactionType,
    required String condition,
  }) =>
      _provider.quickEstimate(
        wilayaId: wilayaId,
        communeId: communeId,
        surface: surface,
        categoryId: categoryId,
        transactionType: transactionType,
        condition: condition,
      );

  /// Submits the completed form and returns the valuation result.
  Future<ValuationResult> submitValuation(Map<String, dynamic> payload) =>
      _provider.submitValuation(payload);

  /// Posts the owner's revised selling price after seeing the report.
  Future<void> submitOwnerEstimateAfter(int valuationId, double amount) =>
      _provider.submitOwnerEstimateAfter(valuationId, amount);
}
