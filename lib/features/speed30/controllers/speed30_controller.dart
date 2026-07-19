import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/commune_model.dart';
import '../../../data/models/speed30_model.dart';
import '../../../data/models/wilaya_model.dart';
import '../../../data/repositories/estimation_repository.dart';
import '../views/speed30_result_sheet.dart';

/// Drives the single-screen "Estimate in 30 seconds" form.
class Speed30Controller extends GetxController {
  final EstimationRepository _repository;
  Speed30Controller(this._repository);

  // ── Location ───────────────────────────────────────────────────────────────
  final wilayas = <Wilaya>[].obs;
  final isLoadingWilayas = false.obs;
  final wilayasError = ''.obs;
  final selectedWilaya = Rx<Wilaya?>(null);

  final communes = <Commune>[].obs;
  final isLoadingCommunes = false.obs;
  final selectedCommune = Rx<Commune?>(null);

  // ── Categories ───────────────────────────────────────────────────────────
  final transactions = <Speed30Transaction>[].obs;
  final isLoadingCategories = false.obs;
  final categoriesError = ''.obs;
  final selectedTxId = 0.obs;
  final selectedTypeId = 0.obs;

  // ── Surface & condition ────────────────────────────────────────────────────
  final surfaceCtrl = TextEditingController(text: '100');
  final surfaceText = '100'.obs;
  final condition = 'good'.obs; // 'new' | 'good' | 'needs_renovation'

  final isSubmitting = false.obs;

  Speed30Transaction? get selectedTx {
    for (final t in transactions) {
      if (t.id == selectedTxId.value) return t;
    }
    return null;
  }

  List<Speed30Type> get currentTypes => selectedTx?.types ?? const [];

  bool get canSubmit =>
      selectedWilaya.value != null &&
      selectedTypeId.value != 0 &&
      (double.tryParse(surfaceText.value) ?? 0) > 0;

  @override
  void onInit() {
    super.onInit();
    surfaceCtrl.addListener(() => surfaceText.value = surfaceCtrl.text);
    _loadWilayas();
    _loadCategories();
  }

  Future<void> _loadWilayas() async {
    try {
      isLoadingWilayas.value = true;
      wilayasError.value = '';
      wilayas.assignAll(await _repository.fetchWilayas());
    } catch (e) {
      wilayasError.value = e.toString();
    } finally {
      isLoadingWilayas.value = false;
    }
  }

  Future<void> _loadCategories() async {
    try {
      isLoadingCategories.value = true;
      categoriesError.value = '';
      final result = await _repository.fetchSpeed30Categories();
      transactions.assignAll(result);
      if (result.isNotEmpty) {
        selectedTxId.value = result.first.id;
        if (result.first.types.isNotEmpty) {
          selectedTypeId.value = result.first.types.first.id;
        }
      }
    } catch (e) {
      categoriesError.value = e.toString();
    } finally {
      isLoadingCategories.value = false;
    }
  }

  void selectTransaction(Speed30Transaction tx) {
    // Preserve the chosen property type across the Sale/Rent switch by code.
    final prevCode = _selectedTypeCode();
    selectedTxId.value = tx.id;
    Speed30Type? match;
    for (final t in tx.types) {
      if (t.code == prevCode) {
        match = t;
        break;
      }
    }
    match ??= tx.types.isNotEmpty ? tx.types.first : null;
    selectedTypeId.value = match?.id ?? 0;
  }

  String? _selectedTypeCode() {
    for (final t in currentTypes) {
      if (t.id == selectedTypeId.value) return t.code;
    }
    return null;
  }

  void selectType(Speed30Type type) => selectedTypeId.value = type.id;

  void selectWilaya(Wilaya w) {
    selectedWilaya.value = w;
    selectedCommune.value = null;
    loadCommunes(w);
  }

  Future<void> loadCommunes(Wilaya wilaya) async {
    communes.clear();
    isLoadingCommunes.value = true;
    try {
      communes.assignAll(await _repository.fetchCommunes(wilaya.id));
    } catch (e) {
      Get.log('Speed30 loadCommunes error: $e');
    } finally {
      isLoadingCommunes.value = false;
    }
  }

  Future<void> submit() async {
    if (!canSubmit || isSubmitting.value) return;
    isSubmitting.value = true;
    try {
      final surface = double.tryParse(surfaceText.value) ?? 0;
      final result = await _repository.quickEstimate(
        wilayaId: selectedWilaya.value!.id,
        communeId: selectedCommune.value?.id,
        surface: surface,
        categoryId: selectedTypeId.value,
        transactionType: selectedTx?.transactionType ?? 'sale',
        condition: condition.value,
      );
      Get.bottomSheet(
        Speed30ResultSheet(
          result: result,
          surface: surface,
          isRent: (selectedTx?.transactionType ?? 'sale') == 'rent',
        ),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
      );
    } catch (e) {
      Get.snackbar('Erreur', e.toString(),
          snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 3));
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    surfaceCtrl.dispose();
    super.onClose();
  }
}
