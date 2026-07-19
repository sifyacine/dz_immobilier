import '../models/property_detail_model.dart';
import '../models/property_model.dart';
import '../models/wilaya_model.dart';
import '../providers/property_provider.dart';

/// Business-facing access point for property and location data.
/// Controllers depend on this, not on [PropertyProvider] directly.
class PropertyRepository {
  final PropertyProvider _provider;
  PropertyRepository(this._provider);

  /// Fetches the first page of the newest listings (home-screen feed).
  Future<({List<Property> items, int total})> getProperties({
    int page = 1,
  }) => _provider.search(page: page, sort: 'newest');

  /// Reads a single listing's full detail by id.
  Future<PropertyDetail> getProperty(int id) => _provider.getById(id);

  /// Wishlist (requires a logged-in user session).
  Future<Map<int, int>> fetchWishlist() => _provider.fetchWishlist();
  Future<void> addToWishlist(int variantId) =>
      _provider.addToWishlist(variantId);
  Future<void> removeFromWishlist(int wishId) =>
      _provider.removeFromWishlist(wishId);

  /// Submits a price offer for a listing.
  Future<void> submitOffer({
    required int productTemplateId,
    required num amount,
    required String financing,
    required String name,
    required String phone,
    String email = '',
    String message = '',
  }) =>
      _provider.submitOffer(
        productTemplateId: productTemplateId,
        amount: amount,
        financing: financing,
        name: name,
        phone: phone,
        email: email,
        message: message,
      );

  /// Executes a filtered/paginated marketplace search.
  Future<({List<Property> items, int total})> search({
    String? query,
    String? transactionType,
    List<String>? propertyTypes,
    int? wilayaId,
    double? minPrice,
    double? maxPrice,
    int? minRooms,
    double? minSurface,
    int page = 1,
    String sort = 'newest',
  }) => _provider.search(
        query: query,
        transactionType: transactionType,
        propertyTypes: propertyTypes,
        wilayaId: wilayaId,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minRooms: minRooms,
        minSurface: minSurface,
        page: page,
        sort: sort,
      );

  /// Returns the 58 Algerian wilayas for filter pickers.
  Future<List<Wilaya>> fetchWilayas() => _provider.fetchWilayas();
}
