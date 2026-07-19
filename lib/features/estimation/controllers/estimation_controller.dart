import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../data/models/commune_model.dart';
import '../../../data/models/form_schema_model.dart';
import '../../../data/models/valuation_category_model.dart';
import '../../../data/models/valuation_result_model.dart';
import '../../../data/models/wilaya_model.dart';
import '../../../data/repositories/estimation_repository.dart';

class EstimationController extends GetxController {
  final EstimationRepository _repository;
  EstimationController(this._repository);

  // ── Navigation ────────────────────────────────────────────────────────────
  final currentStep = 0.obs;
  static const int totalSteps = 5;

  double get progress => (currentStep.value + 1) / totalSteps;

  // ── Step 1 — Location ────────────────────────────────────────────────────
  final wilayas = <Wilaya>[].obs;
  final isLoadingWilayas = false.obs;
  final wilayasError = ''.obs;

  final selectedWilaya = Rx<Wilaya?>(null);
  final communes = <Commune>[].obs;
  final isLoadingCommunes = false.obs;
  final communesError = ''.obs;
  final selectedCommune = Rx<Commune?>(null);
  final neighborhoodCtrl = TextEditingController();

  // ── Step 2 — Property type ───────────────────────────────────────────────
  // Level 1: transaction types (Sale / Rent / Holiday renting)
  final transactionTypes = <ValuationCategory>[].obs;
  final isLoadingCategories = false.obs;
  final categoriesError = ''.obs;
  final selectedTransaction = Rx<ValuationCategory?>(null);

  // Level 2: property types for the selected transaction
  final propertyCategories = <ValuationCategory>[].obs;
  final isLoadingPropertyCategories = false.obs;
  final selectedPropertyCategory = Rx<ValuationCategory?>(null);

  // Level 3: optional sub-types when a property type is selected
  final subCategories = <ValuationCategory>[].obs;
  final isLoadingSubCategories = false.obs;
  final selectedSubCategory = Rx<ValuationCategory?>(null);

  // ── Step 3 — Surface ─────────────────────────────────────────────────────
  final surfaceCtrl = TextEditingController();
  final surfaceText = ''.obs;

  // ── Step 4 — Dynamic form schema ────────────────────────────────────────
  final formSchema = <FormSchemaSection>[].obs;
  final isLoadingSchema = false.obs;
  final schemaError = ''.obs;
  // attributeId → list of selected value IDs (1 element for radio, N for multi)
  final selectedValueIds = <int, List<int>>{}.obs;

  // ── Step 5 — Contact ─────────────────────────────────────────────────────
  final fullNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final fullNameText = ''.obs;
  final phoneText = ''.obs;
  final agreeContact = true.obs;
  final userEstimateCtrl = TextEditingController();
  final isSubmitting = false.obs;

  // ── Result ────────────────────────────────────────────────────────────────
  final valuationResult = Rx<ValuationResult?>(null);
  final submitError = ''.obs;
  // "Updated price — your turn" section on the result screen
  final ownerEstimateAfterCtrl = TextEditingController();
  final ownerEstimateAfterText = ''.obs;
  final isSavingOwnerEstimate = false.obs;
  final ownerEstimateSaved = false.obs;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _loadWilayas();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      isLoadingCategories.value = true;
      categoriesError.value = '';
      final result = await _repository.fetchTransactionTypes();
      transactionTypes.assignAll(result);
    } catch (e) {
      categoriesError.value = e.toString();
      Get.log('_loadCategories error: $e');
    } finally {
      isLoadingCategories.value = false;
    }
  }

  /// Called when the user taps a transaction type tile.
  Future<void> selectTransaction(ValuationCategory tx) async {
    selectedTransaction.value = tx;
    selectedPropertyCategory.value = null;
    subCategories.clear();
    selectedSubCategory.value = null;
    try {
      isLoadingPropertyCategories.value = true;
      final result = await _repository.fetchChildren(tx.id);
      propertyCategories.assignAll(result);
    } catch (e) {
      Get.log('selectTransaction children error: $e');
      propertyCategories.clear();
    } finally {
      isLoadingPropertyCategories.value = false;
    }
  }

  /// Called when the user taps a property type tile.
  Future<void> selectPropertyCategory(ValuationCategory cat) async {
    selectedPropertyCategory.value = cat;
    selectedSubCategory.value = null;
    subCategories.clear();
    selectedValueIds.clear();
    formSchema.clear();
    schemaError.value = '';

    isLoadingSubCategories.value = true;
    try {
      final children = await _repository.fetchChildren(cat.id);
      subCategories.assignAll(children);
    } catch (e) {
      Get.log('selectPropertyCategory sub-types error: $e');
    } finally {
      isLoadingSubCategories.value = false;
    }

    await _loadFormSchema(cat.id);
  }

  /// Called when the user taps a sub-type tile.
  Future<void> selectSubCategory(ValuationCategory sub) async {
    selectedSubCategory.value = sub;
    selectedValueIds.clear();
    formSchema.clear();
    schemaError.value = '';
    await _loadFormSchema(sub.id);
  }

  Future<void> _loadFormSchema(int categoryId) async {
    try {
      isLoadingSchema.value = true;
      final sections = await _repository.fetchFormSchema(categoryId);
      formSchema.assignAll(sections);
    } catch (e) {
      schemaError.value = e.toString();
      Get.log('_loadFormSchema error: $e');
    } finally {
      isLoadingSchema.value = false;
    }
  }

  /// Toggles a value selection. Radio attributes allow only one value at a time;
  /// multi attributes allow any number.
  void toggleAttributeValue(int attributeId, int valueId,
      {required bool isMulti}) {
    final current = List<int>.from(selectedValueIds[attributeId] ?? []);
    if (isMulti) {
      if (current.contains(valueId)) {
        current.remove(valueId);
      } else {
        current.add(valueId);
      }
    } else {
      if (current.length == 1 && current[0] == valueId) {
        current.clear(); // deselect
      } else {
        current
          ..clear()
          ..add(valueId);
      }
    }
    selectedValueIds[attributeId] = current;
  }

  /// Number of selected values across all attributes in [section].
  int sectionSelectedCount(FormSchemaSection section) {
    var count = 0;
    for (final attr in section.attributes) {
      count += (selectedValueIds[attr.attributeId] ?? []).length;
    }
    return count;
  }

  Future<void> _loadWilayas() async {
    try {
      isLoadingWilayas.value = true;
      wilayasError.value = '';
      final result = await _repository.fetchWilayas();
      wilayas.assignAll(result);
    } catch (e) {
      wilayasError.value = e.toString();
    } finally {
      isLoadingWilayas.value = false;
    }
  }

  /// Load communes for the selected wilaya from the picker API.
  Future<void> loadCommunes(Wilaya wilaya) async {
    selectedCommune.value = null;
    communes.clear();
    communesError.value = '';
    isLoadingCommunes.value = true;
    try {
      final result = await _repository.fetchCommunes(wilaya.id);
      communes.assignAll(result);
    } catch (e) {
      communesError.value = e.toString();
      Get.log('loadCommunes error for wilaya ${wilaya.id}: $e');
    } finally {
      isLoadingCommunes.value = false;
    }
  }

  // ── Navigation helpers ────────────────────────────────────────────────────

  void nextStep() {
    if (currentStep.value < totalSteps - 1) {
      currentStep.value++;
    }
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
      case 0: return selectedWilaya.value != null;
      case 1: return selectedTransaction.value != null && selectedPropertyCategory.value != null;
      case 2:
        final v = double.tryParse(surfaceText.value);
        return v != null && v > 0;
      case 3: return true;
      case 4:
        return fullNameText.value.trim().isNotEmpty &&
            phoneText.value.trim().isNotEmpty &&
            agreeContact.value;
      default: return false;
    }
  }

  /// Called from the last step's "Voir mon estimation" button.
  /// Navigates to the loading screen immediately, then runs the API call in
  /// the background. The loading view watches [valuationResult]/[submitError].
  Future<void> submit() async {
    if (isSubmitting.value) return;
    isSubmitting.value = true;
    submitError.value = '';
    valuationResult.value = null;

    Get.toNamed(Routes.estimationLoading);

    try {
      final result = await _repository.submitValuation(_buildPayload());
      valuationResult.value = result;
    } catch (e) {
      submitError.value = e.toString();
      Get.log('submit error: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  Map<String, dynamic> _buildPayload() {
    // Flatten all selected value IDs into a single list
    final allValueIds = selectedValueIds.values
        .expand((ids) => ids)
        .toList();

    return {
      if (selectedTransaction.value != null)
        'transaction_category_id': selectedTransaction.value!.id,
      'property_category_id':
          selectedSubCategory.value?.id
          ?? selectedPropertyCategory.value?.id
          ?? 0,
      if (selectedWilaya.value != null) 'wilaya_id': selectedWilaya.value!.id,
      if (selectedCommune.value != null)
        'commune_id': selectedCommune.value!.id,
      if (neighborhoodCtrl.text.trim().isNotEmpty)
        'neighborhood': neighborhoodCtrl.text.trim(),
      'surface': double.tryParse(surfaceText.value) ?? 0,
      'attribute_value_ids': allValueIds,
      'contact_name': fullNameText.value.trim(),
      'contact_phone': phoneText.value.trim(),
      if (emailCtrl.text.trim().isNotEmpty)
        'contact_email': emailCtrl.text.trim(),
      'contact_consent': agreeContact.value,
      if (userEstimateCtrl.text.trim().isNotEmpty)
        'owner_estimate_before':
            int.tryParse(userEstimateCtrl.text.trim()),
      'owner_estimate_currency': 'DZD',
      'source_url': 'mobile_app',
      'utm_source': 'mobile_app',
      'utm_medium': 'estimation_wizard',
    };
  }

  Future<void> submitOwnerEstimateAfter() async {
    final id = valuationResult.value?.valuationId;
    final amount = double.tryParse(ownerEstimateAfterCtrl.text.trim());
    if (id == null || amount == null || amount <= 0) return;
    isSavingOwnerEstimate.value = true;
    try {
      await _repository.submitOwnerEstimateAfter(id, amount);
      ownerEstimateSaved.value = true;
    } catch (e) {
      Get.log('submitOwnerEstimateAfter error: $e');
    } finally {
      isSavingOwnerEstimate.value = false;
    }
  }

  @override
  void onClose() {
    neighborhoodCtrl.dispose();
    surfaceCtrl.dispose();
    fullNameCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    userEstimateCtrl.dispose();
    ownerEstimateAfterCtrl.dispose();
    super.onClose();
  }
}
