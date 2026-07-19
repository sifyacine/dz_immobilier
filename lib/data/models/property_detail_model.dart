import 'dart:convert';

import '../../app/constants/api_constants.dart';

/// One bank offer from the listing's `dz_credit_banks` JSON.
class CreditBank {
  final String name;
  final String shortName;
  final double rate; // annual %, e.g. 5.0
  final String type; // "Classique" | "Mourabaha"
  final double monthly; // DZD / month
  final bool isIslamic;
  final bool isBest;

  const CreditBank({
    required this.name,
    required this.shortName,
    required this.rate,
    required this.type,
    required this.monthly,
    required this.isIslamic,
    required this.isBest,
  });

  factory CreditBank.fromJson(Map<String, dynamic> j) => CreditBank(
        name: j['name'] as String? ?? '',
        shortName: j['short'] as String? ?? (j['name'] as String? ?? ''),
        rate: (j['rate'] as num?)?.toDouble() ?? 0,
        type: j['type'] as String? ?? '',
        monthly: (j['monthly'] as num?)?.toDouble() ?? 0,
        // Odoo serialises this as bool OR 0.0/1.0.
        isIslamic: j['is_islamic'] == true || j['is_islamic'] == 1 ||
            j['is_islamic'] == 1.0,
        isBest: j['is_best'] == true,
      );
}

/// Full listing detail, built from a `product.template` `read` by id.
///
/// Carries everything the detail screen renders: gallery, price + price/m²,
/// the AI valuation block, DZ reliability scores, credit estimates and the
/// selling agency. All money values are in DZD.
class PropertyDetail {
  final int id;
  final int variantId; // product.product id — required by the wishlist API
  final String ref; // dz_ref_code, e.g. "VLI-0077"
  final String title;
  final double price;
  final String currency;
  final double pricePerSqm;
  final String type; // 'sale' | 'rent'
  final String category;
  final String city;
  final String neighborhood;
  final String descriptionText;

  // Specs
  final double surface;
  final int bedrooms;
  final int bathrooms;
  final int rooms;
  final int parkings;
  final int floorNumber;
  final int floorTotal;
  final String typeLabel; // dz_property_type_label, e.g. "R+2"

  // AI valuation
  final double valuationMin;
  final double valuationMax;
  final double valuationPsqm;
  final double valuationConfidence; // 0..1
  final int comparablesCount;
  final String alignedText; // e.g. "↗ Au-dessus · +54.8% vs médiane"
  final double dgiPsqm;
  final bool dgiCompliant;

  // Credit / financing
  final double creditBestMonthly;
  final double mourabahaMonthly;
  final double creditSavings;
  final List<CreditBank> creditBanks;

  // DZ reliability scores (0..100)
  final int familyScore;
  final int investorScore;
  final int liquidityScore;
  final int rentalScore;
  final int standingScore;
  final int scoreCurrent;
  final String scoreBand;

  // Agency / agent
  final String sellerName;
  final String agentName;
  final String agentPhone;
  final String agentMobile;
  final String agentEmail;
  final String agentResponseTime;
  final String agentInitials;

  // Meta
  final double ratingAvg;
  final int ratingCount;
  final int viewCount;
  final int publishedDaysAgo;
  final bool diasporaFriendly;
  final String websiteUrl;

  final List<String> images;

  const PropertyDetail({
    required this.id,
    this.variantId = 0,
    this.ref = '',
    this.title = '',
    this.price = 0,
    this.currency = 'DZD',
    this.pricePerSqm = 0,
    this.type = 'sale',
    this.category = '',
    this.city = '',
    this.neighborhood = '',
    this.descriptionText = '',
    this.surface = 0,
    this.bedrooms = 0,
    this.bathrooms = 0,
    this.rooms = 0,
    this.parkings = 0,
    this.floorNumber = 0,
    this.floorTotal = 0,
    this.typeLabel = '',
    this.valuationMin = 0,
    this.valuationMax = 0,
    this.valuationPsqm = 0,
    this.valuationConfidence = 0,
    this.comparablesCount = 0,
    this.alignedText = '',
    this.dgiPsqm = 0,
    this.dgiCompliant = false,
    this.creditBestMonthly = 0,
    this.mourabahaMonthly = 0,
    this.creditSavings = 0,
    this.creditBanks = const [],
    this.familyScore = 0,
    this.investorScore = 0,
    this.liquidityScore = 0,
    this.rentalScore = 0,
    this.standingScore = 0,
    this.scoreCurrent = 0,
    this.scoreBand = '',
    this.sellerName = '',
    this.agentName = '',
    this.agentPhone = '',
    this.agentMobile = '',
    this.agentEmail = '',
    this.agentResponseTime = '',
    this.agentInitials = '',
    this.ratingAvg = 0,
    this.ratingCount = 0,
    this.viewCount = 0,
    this.publishedDaysAgo = 0,
    this.diasporaFriendly = false,
    this.websiteUrl = '',
    this.images = const [],
  });

  bool get isRent => type == 'rent';
  bool get hasValuation => valuationMin > 0 && valuationMax > 0;
  bool get hasCredit => creditBestMonthly > 0 || mourabahaMonthly > 0;
  String? get thumbnail => images.isNotEmpty ? images.first : null;

  /// Fields requested from `product.template`.
  static const List<String> fields = [
    'id', 'name', 'dz_ref_code', 'list_price', 'currency_id', 'product_variant_id',
    'wilaya_id', 'commune_id', 'dz_neighborhood', 'categ_id', 'website_url',
    'description_sale', 'website_description',
    'dz_surface_m2', 'dz_bedrooms_count', 'dz_bathrooms_count', 'rooms_count',
    'dz_parkings_count', 'dz_floor_number', 'dz_floor_total',
    'dz_property_type_label',
    'dz_valuation_min', 'dz_valuation_max', 'dz_valuation_psqm',
    'dz_valuation_confidence', 'dz_valuation_comparables_count',
    'dz_valuation_aligned', 'dz_dgi_psqm', 'dz_dgi_compliant',
    'dz_credit_best_monthly', 'dz_mourabaha_monthly', 'dz_credit_savings_total',
    'dz_credit_banks',
    'dz_family_score', 'dz_investor_score', 'dz_liquidity_score',
    'dz_rental_score', 'dz_standing_score', 'dz_score_current', 'dz_score_band',
    'marketplace_seller_id', 'dz_agent_name', 'dz_agent_phone',
    'dz_agent_mobile', 'dz_agent_email', 'dz_agent_response_time',
    'dz_agent_initials',
    'rating_avg', 'rating_count', 'dz_view_count', 'dz_published_days_ago',
    'dz_diaspora_friendly', 'product_template_image_ids',
  ];

  factory PropertyDetail.fromOdoo(Map<String, dynamic> json) {
    final id = json['id'] as int? ?? 0;
    final name = _str(json['name']);
    final surface = _toDouble(json['dz_surface_m2']);
    final price = _toDouble(json['list_price']);

    String city = _m2oName(json['wilaya_id'])
        .replaceAll(RegExp(r'\s*\(DZ\)\s*$'), '')
        .trim();
    final neighborhood = _str(json['dz_neighborhood']);
    final commune = _m2oName(json['commune_id']);

    String category = '';
    final categ = json['categ_id'];
    if (categ is List && categ.length > 1) {
      category = _mapCategory(categ[1].toString().split('/').last.trim());
    }

    // description_sale is plain text (with emojis); fall back to stripped HTML.
    var description = _str(json['description_sale']);
    if (description.isEmpty) {
      description = _stripHtml(_str(json['website_description']));
    }

    // Gallery: main template image first, then each product.image.
    final images = <String>[
      '${ApiConstants.baseUrl}/web/image/product.template/$id/image_1024',
    ];
    final gallery = json['product_template_image_ids'];
    if (gallery is List) {
      for (final imgId in gallery) {
        if (imgId is int) {
          images.add(
              '${ApiConstants.baseUrl}/web/image/product.image/$imgId/image_1024');
        }
      }
    }

    return PropertyDetail(
      id: id,
      variantId: _m2oId(json['product_variant_id']),
      ref: _str(json['dz_ref_code']),
      title: name,
      price: price,
      currency: _m2oName(json['currency_id']).isNotEmpty
          ? _m2oName(json['currency_id'])
          : 'DZD',
      pricePerSqm: surface > 0
          ? price / surface
          : _toDouble(json['dz_valuation_psqm']),
      type: _guessType(name),
      category: category,
      city: city.isNotEmpty ? city : commune,
      neighborhood: neighborhood,
      descriptionText: description,
      surface: surface,
      bedrooms: _toInt(json['dz_bedrooms_count']),
      bathrooms: _toInt(json['dz_bathrooms_count']),
      rooms: _toInt(json['rooms_count']),
      parkings: _toInt(json['dz_parkings_count']),
      floorNumber: _toInt(json['dz_floor_number']),
      floorTotal: _toInt(json['dz_floor_total']),
      typeLabel: _str(json['dz_property_type_label']),
      valuationMin: _toDouble(json['dz_valuation_min']),
      valuationMax: _toDouble(json['dz_valuation_max']),
      valuationPsqm: _toDouble(json['dz_valuation_psqm']),
      valuationConfidence: _toDouble(json['dz_valuation_confidence']),
      comparablesCount: _toInt(json['dz_valuation_comparables_count']),
      alignedText: _str(json['dz_valuation_aligned']),
      dgiPsqm: _toDouble(json['dz_dgi_psqm']),
      dgiCompliant: json['dz_dgi_compliant'] == true,
      creditBestMonthly: _toDouble(json['dz_credit_best_monthly']),
      mourabahaMonthly: _toDouble(json['dz_mourabaha_monthly']),
      creditSavings: _toDouble(json['dz_credit_savings_total']),
      creditBanks: _parseCreditBanks(json['dz_credit_banks']),
      familyScore: _toInt(json['dz_family_score']),
      investorScore: _toInt(json['dz_investor_score']),
      liquidityScore: _toInt(json['dz_liquidity_score']),
      rentalScore: _toInt(json['dz_rental_score']),
      standingScore: _toInt(json['dz_standing_score']),
      scoreCurrent: _toInt(json['dz_score_current']),
      scoreBand: _str(json['dz_score_band']),
      sellerName: _m2oName(json['marketplace_seller_id']),
      agentName: _str(json['dz_agent_name']),
      agentPhone: _str(json['dz_agent_phone']),
      agentMobile: _str(json['dz_agent_mobile']),
      agentEmail: _str(json['dz_agent_email']),
      agentResponseTime: _str(json['dz_agent_response_time']),
      agentInitials: _str(json['dz_agent_initials']),
      ratingAvg: _toDouble(json['rating_avg']),
      ratingCount: _toInt(json['rating_count']),
      viewCount: _toInt(json['dz_view_count']),
      publishedDaysAgo: _toInt(json['dz_published_days_ago']),
      diasporaFriendly: json['dz_diaspora_friendly'] == true,
      websiteUrl: _str(json['website_url']),
      images: images,
    );
  }

  // ── Parse helpers (Odoo returns `false` for empty values) ──────────────────
  static List<CreditBank> _parseCreditBanks(dynamic raw) {
    if (raw is! String || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .whereType<Map<String, dynamic>>()
            .map(CreditBank.fromJson)
            .toList();
      }
    } catch (_) {
      // Malformed JSON — fall back to the scalar credit fields.
    }
    return const [];
  }

  static String _str(dynamic v) => v is String ? v : '';
  static double _toDouble(dynamic v) => v is num ? v.toDouble() : 0;
  static int _toInt(dynamic v) => v is int ? v : (v is num ? v.toInt() : 0);
  static String _m2oName(dynamic v) =>
      (v is List && v.length > 1) ? v[1].toString() : '';
  static int _m2oId(dynamic v) =>
      (v is List && v.isNotEmpty && v.first is int) ? v.first as int : 0;

  static String _stripHtml(String html) => html
      .replaceAll(RegExp(r'<[^>]*>'), ' ')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll(RegExp(r'[ \t]+'), ' ')
      .replaceAll(RegExp(r'\n\s*\n+'), '\n\n')
      .trim();

  static String _guessType(String name) {
    final l = name.toLowerCase();
    if (l.contains('location') || l.contains('louer') || l.contains('rent')) {
      return 'rent';
    }
    return 'sale';
  }

  static String _mapCategory(String name) {
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
}
