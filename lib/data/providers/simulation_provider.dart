import '../../app/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exceptions.dart';
import '../models/simulation_category_model.dart';
import '../models/simulation_result_model.dart';

class SimulationProvider {
  final ApiClient _client;
  SimulationProvider(this._client);

  Future<List<SimulationCategory>> fetchCategories() async {
    final result = await _client.call(ApiConstants.creditPropertyCategories);
    final list = (result['categories'] as List)
        .map((e) => SimulationCategory.fromJson(e as Map<String, dynamic>))
        .toList();
    return list;
  }

  /// Computes + persists a credit simulation (`/credit/calculate`) and returns
  /// the conventional vs Mourabaha breakdown (incl. the `id` for lead capture).
  Future<SimulationResult> calculate(Map<String, dynamic> params) async {
    final result = await _client.call(
      ApiConstants.creditCalculate,
      params: params,
    );
    // Success returns `error: false`; validation failures return a string.
    final err = (result is Map<String, dynamic>) ? result['error'] : null;
    if (err is String && err.isNotEmpty) {
      throw ApiException(err);
    }
    return SimulationResult.fromJson(result as Map<String, dynamic>);
  }

  /// Registers the lead for a computed simulation (`/credit/submit_lead`).
  /// Requires the `simulation_id` returned by [calculate].
  Future<void> submitLead(Map<String, dynamic> params) async {
    await _client.call(ApiConstants.creditSubmitLead, params: params);
  }

  /// Returns one offer per partner bank for the given budget/profile.
  /// Expected params: `price`, `down_payment`, `income`, `age`, `funding_type`.
  Future<List<BankOffer>> compareAll(Map<String, dynamic> params) async {
    final result = await _client.call(
      ApiConstants.creditCompareAll,
      params: params,
    );
    return (result as List)
        .map((e) => BankOffer.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
