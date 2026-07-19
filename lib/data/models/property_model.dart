import 'package:dz_immobilier/app/constants/api_constants.dart';

/// A real-estate listing.
///
/// Three factories:
/// - [fromOdoo]        — maps `product.template search_read` fields (active)
/// - [fromMarketplace] — legacy (endpoint no longer exists, kept for reference)
/// - [fromJson]        — re-hydrates from locally stored JSON
class Property {
  final int id;
  final String title;
  final String description;
  final double price;
  final String currency;
  final String type; // 'sale' | 'rent'
  final String category; // 'Appartement' | 'Villa' | 'Terrain' | ...
  final String city; // wilaya name
  final String address; // commune name
  final int bedrooms;
  final int bathrooms;
  final double area; // m²
  final List<String> images;
  final bool isFeatured;
  final String slug; // Odoo product URL slug
  final String sellerName;

  const Property({
    required this.id,
    required this.title,
    this.description = '',
    required this.price,
    this.currency = 'DZD',
    this.type = 'sale',
    this.category = '',
    this.city = '',
    this.address = '',
    this.bedrooms = 0,
    this.bathrooms = 0,
    this.area = 0,
    this.images = const [],
    this.isFeatured = false,
    this.slug = '',
    this.sellerName = '',
  });

  String? get thumbnail => images.isNotEmpty ? images.first : null;
  bool get isRent => type == 'rent';

  /// Build from `product.template search_read` (Odoo callKw).
  ///
  /// Fields expected: id, name, list_price, currency_id, wilaya_id, commune_id,
  /// dz_neighborhood, dz_surface_m2, dz_bedrooms_count, dz_bathrooms_count,
  /// rooms_count, dz_property_type_label, dz_ref_code, categ_id,
  /// marketplace_seller_id, dz_agent_name, dz_agent_phone, website_url.
  factory Property.fromOdoo(Map<String, dynamic> json) {
    final id = json['id'] as int? ?? 0;
    final nameStr = json['name'] as String? ?? '';

    // categ_id → [554, "All / Saleable / Sale / Villa"] — last path segment.
    String category = '';
    final categ = json['categ_id'];
    if (categ is List && categ.length > 1) {
      category = _mapCategoryName(categ[1].toString().split('/').last.trim());
    }
    // Fall back to the dz label (e.g. "R+2", "F4") when category is unhelpful.
    final typeLabel = json['dz_property_type_label'];
    if (category.isEmpty && typeLabel is String && typeLabel.trim() != '—') {
      category = typeLabel.trim();
    }

    // Location — prefer real fields, fall back to parsing the title.
    String city = _m2oName(json['wilaya_id'])
        .replaceAll(RegExp(r'\s*\(DZ\)\s*$'), '')
        .trim();
    final commune = _m2oName(json['commune_id']);
    final neighborhood =
        json['dz_neighborhood'] is String ? json['dz_neighborhood'] as String : '';

    // Titles read "Vente Villa … – Quartier, Commune, Ville".
    String address = '';
    final dashIdx = nameStr.indexOf('–');
    if (dashIdx != -1) {
      address = nameStr.substring(dashIdx + 1).trim();
    } else {
      address = [neighborhood, commune, city]
          .where((s) => s.isNotEmpty)
          .join(', ');
    }
    if (city.isEmpty && address.isNotEmpty) {
      city = address.split(',').last.trim();
    }

    final currency = _m2oName(json['currency_id']);
    final websiteUrl = json['website_url'] as String? ?? '';

    return Property(
      id: id,
      title: nameStr,
      price: (json['list_price'] as num?)?.toDouble() ?? 0,
      currency: currency.isNotEmpty ? currency : 'DZD',
      type: _guessTransactionType(nameStr),
      category: category,
      city: city,
      address: address.isNotEmpty ? address : city,
      bedrooms: json['dz_bedrooms_count'] as int? ?? 0,
      bathrooms: json['dz_bathrooms_count'] as int? ?? 0,
      area: (json['dz_surface_m2'] as num?)?.toDouble() ?? 0,
      slug: websiteUrl,
      sellerName: _m2oName(json['marketplace_seller_id']),
      images: [
        '${ApiConstants.baseUrl}/web/image/product.template/$id/image_512',
      ],
    );
  }

  /// Extracts the display name from an Odoo many2one pair `[id, "Name"]`.
  static String _m2oName(dynamic value) =>
      (value is List && value.length > 1) ? value[1].toString() : '';

  /// Translates English product-category names to French listing labels.
  static String _mapCategoryName(String name) {
    switch (name.toLowerCase()) {
      case 'apartment': return 'Appartement';
      case 'villa': return 'Villa';
      case 'garage': return 'Garage';
      case 'land': return 'Terrain';
      case 'commercial': return 'Local commercial';
      case 'office': return 'Bureau';
      case 'studio': return 'Studio';
      default: return name;
    }
  }

  static String _guessTransactionType(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('rent') ||
        lower.contains('louer') ||
        lower.contains('location')) {
      return 'rent';
    }
    return 'sale';
  }

  /// Build from the `/api/marketplace/v1/search` response item.
  factory Property.fromMarketplace(Map<String, dynamic> json) {
    final thumbnail = json['thumbnail'] as String?;
    return Property(
      id: json['id'] as int? ?? 0,
      title: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      currency: json['currency'] as String? ?? 'DZD',
      type: json['transaction_type'] as String? ?? 'sale',
      category: _mapPropertyType(json['property_type'] as String? ?? ''),
      city: json['wilaya'] as String? ?? '',
      address: json['commune'] as String? ?? '',
      area: (json['surface'] as num?)?.toDouble() ?? 0,
      bedrooms: json['rooms'] as int? ?? 0,
      images: thumbnail != null ? [thumbnail] : [],
      isFeatured: (json['labels'] as List?)?.contains('featured') ?? false,
      slug: json['slug'] as String? ?? '',
      sellerName: (json['seller'] as Map<String, dynamic>?)?['name'] as String? ?? '',
    );
  }

  /// Re-hydrate from locally stored JSON (written via [toJson]).
  factory Property.fromJson(Map<String, dynamic> json) => Property(
        id: json['id'] as int? ?? 0,
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0,
        currency: json['currency'] as String? ?? 'DZD',
        type: json['type'] as String? ?? 'sale',
        category: json['category'] as String? ?? '',
        city: json['city'] as String? ?? '',
        address: json['address'] as String? ?? '',
        bedrooms: json['bedrooms'] as int? ?? 0,
        bathrooms: json['bathrooms'] as int? ?? 0,
        area: (json['area'] as num?)?.toDouble() ?? 0,
        images: (json['images'] as List?)?.map((e) => e.toString()).toList() ??
            const [],
        isFeatured: json['is_featured'] as bool? ?? false,
        slug: json['slug'] as String? ?? '',
        sellerName: json['seller_name'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'currency': currency,
        'type': type,
        'category': category,
        'city': city,
        'address': address,
        'bedrooms': bedrooms,
        'bathrooms': bathrooms,
        'area': area,
        'images': images,
        'is_featured': isFeatured,
        'slug': slug,
        'seller_name': sellerName,
      };

  static String _mapPropertyType(String apiType) {
    switch (apiType.toLowerCase()) {
      case 'apartment':
        return 'Appartement';
      case 'villa':
        return 'Villa';
      case 'land':
        return 'Terrain';
      case 'commercial':
        return 'Commercial';
      case 'office':
        return 'Bureau';
      default:
        return apiType;
    }
  }
}
