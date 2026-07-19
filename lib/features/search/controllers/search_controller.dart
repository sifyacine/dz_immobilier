import 'package:get/get.dart';

import '../../../data/models/property_model.dart';
import '../../../data/models/wilaya_model.dart';
import '../../../data/repositories/property_repository.dart';

/// Drives the search tab: server-side search, filters, pagination and
/// recent searches.
///
/// Text-input changes are debounced (400 ms) before hitting the API.
/// Filter changes require an explicit [applySearch] call (from the
/// filter bottom sheet's "Appliquer" button) so that multiple filter
/// changes are batched into one request.
class SearchController extends GetxController {
  final PropertyRepository _repository;
  SearchController(this._repository);

  // ── Wilayas (loaded once for the filter picker) ───────────────────────────
  final RxList<Wilaya> wilayas = <Wilaya>[].obs;

  // ── Search state ──────────────────────────────────────────────────────────
  final RxList<Property> results = <Property>[].obs;
  final RxInt total = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString error = ''.obs;

  // ── Query ─────────────────────────────────────────────────────────────────
  final RxString searchQuery = ''.obs;
  final RxList<String> recentSearches = <String>[].obs;

  // ── Filters ───────────────────────────────────────────────────────────────
  final RxString selectedType = 'all'.obs; // 'all' | 'sale' | 'rent'
  final RxString selectedCategory = 'all'.obs;
  final Rx<int?> selectedWilayaId = Rx<int?>(null);
  final Rx<double?> minPrice = Rx<double?>(null);
  final Rx<double?> maxPrice = Rx<double?>(null);
  final RxInt minBedrooms = 0.obs;
  final Rx<double?> minArea = Rx<double?>(null);

  // ── Pagination ────────────────────────────────────────────────────────────
  int _page = 1;
  bool get hasMore => results.length < total.value;

  // ── Convenience for the view ──────────────────────────────────────────────
  /// Alias used by SearchView so it doesn't need renaming.
  List<Property> get filteredProperties => results;

  bool get isFilterActive =>
      selectedType.value != 'all' ||
      selectedCategory.value != 'all' ||
      selectedWilayaId.value != null ||
      minPrice.value != null ||
      maxPrice.value != null ||
      minBedrooms.value > 0 ||
      minArea.value != null;

  @override
  void onInit() {
    super.onInit();
    _loadWilayas();
    // Initial load: newest listings (no filters, no query)
    _runSearch(reset: true);
    // Debounce text input — fires 400 ms after the user stops typing
    debounce(
      searchQuery,
      (_) => _runSearch(reset: true),
      time: const Duration(milliseconds: 400),
    );
  }

  // ── Public API ────────────────────────────────────────────────────────────

  /// Called by FilterBottomSheet after writing filter values to this controller.
  Future<void> applySearch() => _runSearch(reset: true);

  /// Appends the next page. Called by the scroll listener.
  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore.value || isLoading.value) return;
    _page++;
    await _runSearch(reset: false);
  }

  void resetFilters() {
    selectedType.value = 'all';
    selectedCategory.value = 'all';
    selectedWilayaId.value = null;
    minPrice.value = null;
    maxPrice.value = null;
    minBedrooms.value = 0;
    minArea.value = null;
    _runSearch(reset: true);
  }

  void addRecentSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    recentSearches.remove(trimmed);
    recentSearches.insert(0, trimmed);
    if (recentSearches.length > 5) recentSearches.removeLast();
  }

  void clearRecentSearches() => recentSearches.clear();

  // ── Private ───────────────────────────────────────────────────────────────

  Future<void> _loadWilayas() async {
    try {
      wilayas.value = await _repository.fetchWilayas();
    } catch (_) {
      // Fail silently — the filter will still work with the text-based city chips
    }
  }

  Future<void> _runSearch({required bool reset}) async {
    if (reset) {
      _page = 1;
      isLoading.value = true;
      error.value = '';
    } else {
      isLoadingMore.value = true;
    }

    try {
      final result = await _repository.search(
        query: searchQuery.value.trim().isEmpty
            ? null
            : searchQuery.value.trim(),
        transactionType:
            selectedType.value == 'all' ? null : selectedType.value,
        propertyTypes: _mappedPropertyTypes(),
        wilayaId: selectedWilayaId.value,
        minPrice: minPrice.value,
        maxPrice: maxPrice.value,
        minRooms:
            minBedrooms.value > 0 ? minBedrooms.value : null,
        minSurface: minArea.value,
        page: _page,
      );

      if (reset) {
        results.value = result.items;
      } else {
        results.addAll(result.items);
      }
      total.value = result.total;
    } catch (e) {
      if (reset) error.value = e.toString();
      if (!reset) _page--;
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  /// Maps the French category label to the Odoo `property_types` API values.
  List<String>? _mappedPropertyTypes() {
    switch (selectedCategory.value) {
      case 'Appartement':
        return ['apartment'];
      case 'Villa':
        return ['villa'];
      case 'Terrain':
        return ['land'];
      case 'Studio':
        return ['apartment'];
      case 'Bureau':
        return ['office'];
      default:
        return null;
    }
  }
}
