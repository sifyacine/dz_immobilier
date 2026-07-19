import 'package:get/get.dart';

import '../../../data/models/property_model.dart';
import '../../../data/repositories/property_repository.dart';

/// Drives the home property listing: initial load, pull-to-refresh, load-more.
class PropertiesController extends GetxController {
  final PropertyRepository _repository;
  PropertiesController(this._repository);

  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString error = ''.obs;
  final RxList<Property> properties = <Property>[].obs;
  final RxInt total = 0.obs;

  int _page = 1;
  bool get hasMore => properties.length < total.value;

  @override
  void onInit() {
    super.onInit();
    loadProperties();
  }

  /// Initial load / pull-to-refresh — resets to page 1.
  Future<void> loadProperties() async {
    try {
      _page = 1;
      isLoading.value = true;
      error.value = '';
      final result = await _repository.getProperties(page: 1);
      properties.value = result.items;
      total.value = result.total;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Appends the next page to the list. No-op when all pages are loaded.
  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore.value || isLoading.value) return;
    try {
      _page++;
      isLoadingMore.value = true;
      final result = await _repository.getProperties(page: _page);
      properties.addAll(result.items);
      total.value = result.total;
    } catch (_) {
      _page--;
    } finally {
      isLoadingMore.value = false;
    }
  }
}
