import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../data/models/simulation_category_model.dart';
import '../../../data/models/simulation_result_model.dart';
import '../../../data/repositories/simulation_repository.dart';

class SimulationController extends GetxController {
  final SimulationRepository _repository;
  SimulationController(this._repository);

  // ── Navigation ─────────────────────────────────────────────────────────────
  final currentStep = 0.obs;
  static const int totalSteps = 4;

  double get progress => (currentStep.value + 1) / totalSteps;

  // ── Step 1 — Property categories ──────────────────────────────────────────
  final categories = <SimulationCategory>[].obs;
  final isLoadingCategories = false.obs;
  final categoriesError = ''.obs;
  final selectedCategoryIds = <int>[].obs;
  final isStateSubsidized = false.obs;

  void toggleCategory(int id) {
    if (selectedCategoryIds.contains(id)) {
      selectedCategoryIds.remove(id);
    } else {
      selectedCategoryIds.add(id);
    }
  }

  // ── Step 2 — Budget ────────────────────────────────────────────────────────
  final propertyPriceCtrl = TextEditingController();
  final downPaymentCtrl = TextEditingController();
  final propertyPriceText = ''.obs;
  final downPaymentText = ''.obs;

  double get propertyPrice => double.tryParse(propertyPriceText.value) ?? 0;
  double get downPayment => double.tryParse(downPaymentText.value) ?? 0;

  // ── Step 3 — Income ────────────────────────────────────────────────────────
  final netIncomeCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final netIncomeText = ''.obs;
  final ageText = ''.obs;
  final selectedEmploymentType = ''.obs;

  double get netIncome => double.tryParse(netIncomeText.value) ?? 0;
  int get age => int.tryParse(ageText.value) ?? 0;
  int get maxLoanTerm => (age > 0 && age < 75) ? (75 - age) : 0;

  // Stable codes — labels are localized in the view. The value is only used to
  // gate step validation; it is not sent to the backend.
  static const List<String> employmentTypes = [
    'salaried',
    'civil_servant',
    'self_employed',
    'business_owner',
  ];

  // ── Step 4 — Contact ───────────────────────────────────────────────────────
  final fullNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final fullNameText = ''.obs;
  final phoneText = ''.obs;

  // ── Result ─────────────────────────────────────────────────────────────────
  final simulationResult = Rx<SimulationResult?>(null);
  final bankOffers = <BankOffer>[].obs;
  final isSubmitting = false.obs;
  final submitError = ''.obs;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    isLoadingCategories.value = true;
    categoriesError.value = '';
    try {
      final list = await _repository.fetchCategories();
      categories.assignAll(list);
    } catch (e) {
      categoriesError.value = e.toString();
      Get.log('_loadCategories error: $e');
    } finally {
      isLoadingCategories.value = false;
    }
  }

  // ── Wizard navigation ──────────────────────────────────────────────────────

  void nextStep() {
    if (currentStep.value < totalSteps - 1) currentStep.value++;
  }

  void prevStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }

  bool get canProceed {
    switch (currentStep.value) {
      case 0:
        return selectedCategoryIds.isNotEmpty;
      case 1:
        return propertyPrice > 0;
      case 2:
        return netIncome > 0 &&
            age > 0 &&
            selectedEmploymentType.value.isNotEmpty;
      case 3:
        return fullNameText.value.trim().isNotEmpty &&
            phoneText.value.trim().isNotEmpty;
      default:
        return false;
    }
  }

  String get _fundingType => isStateSubsidized.value ? 'bonified' : 'standard';

  String get _propertyType {
    for (final c in categories) {
      if (selectedCategoryIds.contains(c.id)) return c.internalType;
    }
    return 'apartment';
  }

  Future<void> submit() async {
    if (isSubmitting.value) return;
    isSubmitting.value = true;
    submitError.value = '';
    simulationResult.value = null;
    bankOffers.clear();

    Get.toNamed(Routes.simulationResult);

    try {
      // 1) Live per-bank comparison (correct param names for /credit/compare_all).
      final offers = await _repository.compareAll({
        'price': propertyPrice,
        'down_payment': downPayment,
        'income': netIncome,
        'age': age,
        'funding_type': _fundingType,
      });
      bankOffers.assignAll(offers);

      // 2) Detailed conventional-vs-Mourabaha calc (persists, returns id).
      BankOffer? best;
      for (final o in offers) {
        if (o.monthlyPayment <= 0) continue;
        if (best == null || o.monthlyPayment < best.monthlyPayment) best = o;
      }
      final result = await _repository.calculate({
        'bank_id': best?.bankId ?? (offers.isNotEmpty ? offers.first.bankId : 11),
        'property_type': _propertyType,
        'funding_type': _fundingType,
        'property_price': propertyPrice,
        'down_payment': downPayment,
        'monthly_income': netIncome,
        'age': age,
        'duration': best?.duration ?? (maxLoanTerm > 0 ? maxLoanTerm : 25),
        'name': fullNameText.value.trim(),
        'phone': phoneText.value.trim(),
      });
      simulationResult.value = result;

      // 3) Register the lead (best-effort — don't fail the screen on this).
      try {
        await _repository.submitLead({
          'simulation_id': result.id,
          'name': fullNameText.value.trim(),
          'phone': phoneText.value.trim(),
          'email': emailCtrl.text.trim(),
        });
      } catch (e) {
        Get.log('submitLead (non-fatal) error: $e');
      }
    } catch (e) {
      submitError.value = e.toString();
      Get.log('simulation submit error: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  void startNewSimulation() {
    simulationResult.value = null;
    bankOffers.clear();
    selectedCategoryIds.clear();
    isStateSubsidized.value = false;
    propertyPriceCtrl.clear();
    downPaymentCtrl.clear();
    propertyPriceText.value = '';
    downPaymentText.value = '';
    netIncomeCtrl.clear();
    ageCtrl.clear();
    netIncomeText.value = '';
    ageText.value = '';
    selectedEmploymentType.value = '';
    fullNameCtrl.clear();
    phoneCtrl.clear();
    emailCtrl.clear();
    fullNameText.value = '';
    phoneText.value = '';
    submitError.value = '';
    currentStep.value = 0;
    Get.back(); // back to wizard
  }

  @override
  void onClose() {
    propertyPriceCtrl.dispose();
    downPaymentCtrl.dispose();
    netIncomeCtrl.dispose();
    ageCtrl.dispose();
    fullNameCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    super.onClose();
  }
}
