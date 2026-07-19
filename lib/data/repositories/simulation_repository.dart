import '../models/simulation_category_model.dart';
import '../models/simulation_result_model.dart';
import '../providers/simulation_provider.dart';

class SimulationRepository {
  final SimulationProvider _provider;
  SimulationRepository(this._provider);

  Future<List<SimulationCategory>> fetchCategories() =>
      _provider.fetchCategories();

  Future<SimulationResult> calculate(Map<String, dynamic> params) =>
      _provider.calculate(params);

  Future<void> submitLead(Map<String, dynamic> params) =>
      _provider.submitLead(params);

  Future<List<BankOffer>> compareAll(Map<String, dynamic> params) =>
      _provider.compareAll(params);
}
