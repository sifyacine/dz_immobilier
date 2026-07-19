import '../../app/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exceptions.dart';
import '../models/property_detail_model.dart';
import '../models/property_model.dart';
import '../models/wilaya_model.dart';

/// Marketplace and location data sources.
///
/// All calls use [ApiClient.call] (JSON-RPC 2.0 envelope).
/// The search result is returned as a record `({items, total})` so callers
/// can drive both the list display and the pagination counter.
class PropertyProvider {
  final ApiClient _api;
  PropertyProvider(this._api);

  /// Searches published listings via Odoo `product.template search_read`.
  ///
  /// Translates the app's filter vocabulary to Odoo domain expressions.
  Future<({List<Property> items, int total})> search({
    String? query,
    String? transactionType, // 'sale' | 'rent'
    List<String>? propertyTypes, // e.g. ['apartment', 'villa']
    int? wilayaId,
    double? minPrice,
    double? maxPrice,
    int? minRooms,
    double? minSurface,
    int page = 1,
    int pageSize = 20,
    String sort = 'newest',
  }) async {
    // Published marketplace listings only. `website_published = true` matches
    // exactly the real-estate listings (all carry a marketplace_seller_id).
    final domain = <dynamic>[
      ['website_published', '=', true],
    ];

    if (query != null && query.isNotEmpty) {
      domain.add(['name', 'ilike', query]);
    }

    // Titles are French ("Vente …" / "Location …" / "… à louer").
    if (transactionType == 'sale') {
      domain.add(['name', 'ilike', 'vente']);
    } else if (transactionType == 'rent') {
      domain.add('|');
      domain.add(['name', 'ilike', 'location']);
      domain.add(['name', 'ilike', 'louer']);
    }

    if (propertyTypes != null && propertyTypes.isNotEmpty) {
      final names = propertyTypes
          .map(_typeToCategName)
          .whereType<String>()
          .toList();
      if (names.isNotEmpty) {
        // Odoo prefix OR: (n-1) '|' operators then n leaf conditions
        for (int i = 0; i < names.length - 1; i++) {
          domain.add('|');
        }
        for (final name in names) {
          domain.add(['categ_id.name', '=', name]);
        }
      }
    }

    if (minPrice != null) domain.add(['list_price', '>=', minPrice]);
    if (maxPrice != null) domain.add(['list_price', '<=', maxPrice]);

    const fields = [
      'id', 'name', 'list_price', 'currency_id',
      'wilaya_id', 'commune_id', 'dz_neighborhood',
      'dz_surface_m2', 'dz_bedrooms_count', 'dz_bathrooms_count', 'rooms_count',
      'dz_property_type_label', 'dz_ref_code', 'categ_id',
      'marketplace_seller_id', 'dz_agent_name', 'dz_agent_phone',
      'website_url',
    ];

    final results = await Future.wait([
      _api.callKw(
        model: 'product.template',
        method: 'search_count',
        args: [domain],
      ),
      _api.callKw(
        model: 'product.template',
        method: 'search_read',
        args: [domain],
        kwargs: {
          'fields': fields,
          'limit': pageSize,
          'offset': (page - 1) * pageSize,
          'order': sort == 'newest' ? 'id desc' : 'list_price asc',
        },
      ),
    ]);

    final total = (results[0] as num?)?.toInt() ?? 0;
    final items = (results[1] as List? ?? [])
        .map((e) => Property.fromOdoo(e as Map<String, dynamic>))
        .toList();

    return (items: items, total: total);
  }

  /// Maps internal property-type keys to Odoo product category names.
  /// Category names on the server are English (e.g. "Villa", "Apartment").
  static String? _typeToCategName(String type) {
    switch (type.toLowerCase()) {
      case 'apartment': return 'Apartment';
      case 'villa':     return 'Villa';
      case 'land':      return 'Land';
      case 'commercial': return 'Commercial';
      case 'office':    return 'Office';
      default:          return null;
    }
  }

  /// Reads a single listing's full detail by `product.template` id.
  Future<PropertyDetail> getById(int id) async {
    final result = await _api.callKw(
      model: 'product.template',
      method: 'read',
      args: [
        [id],
        PropertyDetail.fields,
      ],
    );
    final list = result as List? ?? const [];
    if (list.isEmpty) {
      throw ApiException('Annonce introuvable.');
    }
    return PropertyDetail.fromOdoo(list.first as Map<String, dynamic>);
  }

  // ── Wishlist (website_sale) ────────────────────────────────────────────────
  // Backed by Odoo's `product.wishlist` + `/shop/wishlist/*` controllers.
  // Requires a logged-in user session (gate at the UI level).

  /// Map of wishlisted product *variant* id → wishlist record id for the
  /// current user. Empty when not logged in / on error.
  Future<Map<int, int>> fetchWishlist() async {
    final result = await _api.callKw(
      model: 'product.wishlist',
      method: 'search_read',
      args: [
        [],
        ['id', 'product_id'],
      ],
    );
    final map = <int, int>{};
    for (final row in (result as List? ?? const [])) {
      final m = row as Map<String, dynamic>;
      final pid = m['product_id'];
      if (pid is List && pid.isNotEmpty && pid.first is int) {
        map[pid.first as int] = m['id'] as int;
      }
    }
    return map;
  }

  /// Adds a product *variant* to the wishlist (`POST /shop/wishlist/add`).
  Future<void> addToWishlist(int variantId) =>
      _api.call('/shop/wishlist/add', params: {'product_id': variantId});

  /// Removes a wishlist record by id (`POST /shop/wishlist/remove/<id>`).
  Future<void> removeFromWishlist(int wishId) =>
      _api.call('/shop/wishlist/remove/$wishId', params: {});

  /// Submits a price offer for a listing (`POST /dz/listing/offer-request`).
  /// Public endpoint — works for guests and logged-in users alike.
  /// Throws [ApiException] with the server message when the offer is rejected.
  Future<void> submitOffer({
    required int productTemplateId,
    required num amount,
    required String financing, // 'cash' | 'classic' | 'mourabaha'
    required String name,
    required String phone,
    String email = '',
    String message = '',
  }) async {
    final result = await _api.call('/dz/listing/offer-request', params: {
      'product_tmpl_id': productTemplateId,
      'offer_amount': amount,
      'financing': financing,
      'visitor_name': name,
      'visitor_phone': phone,
      'visitor_email': email,
      'message': message,
    });
    final map = result as Map<String, dynamic>?;
    if (map == null || map['success'] != true) {
      throw ApiException(
          (map?['error'] as String?) ?? "Échec de l'envoi de l'offre.");
    }
  }

  /// Fetches the list of 58 Algerian wilayas from `/api/picker/wilayas`.
  Future<List<Wilaya>> fetchWilayas() async {
    final result = await _api.call(ApiConstants.pickWilayas, params: {'lang': 'fr_FR'});
    // API returns `{"wilayas": [...]}`. Fall back to a flat array defensively.
    final list = result is Map<String, dynamic>
        ? (result['wilayas'] as List? ?? const [])
        : (result as List? ?? const []);
    return list
        .map((e) => Wilaya.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
