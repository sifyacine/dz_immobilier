// Models for the Speed30 ("estimate in 30 seconds") flow.
//
// `/api/valuation/v1/speed30_categories` returns a list of transaction
// categories, each holding its curated property types.

class Speed30Type {
  final int id;
  final String name; // localized, e.g. "Appartement"
  final String code; // English key, e.g. "Apartment"

  const Speed30Type({required this.id, required this.name, required this.code});

  factory Speed30Type.fromJson(Map<String, dynamic> json) => Speed30Type(
        id: json['id'] as int? ?? 0,
        name: json['name'] as String? ?? '',
        code: json['code'] as String? ?? '',
      );
}

class Speed30Transaction {
  final int id; // 1 = Vente, 2 = Location
  final String name; // "Vente" / "Location"
  final List<Speed30Type> types;

  const Speed30Transaction({
    required this.id,
    required this.name,
    required this.types,
  });

  factory Speed30Transaction.fromJson(Map<String, dynamic> json) =>
      Speed30Transaction(
        id: json['id'] as int? ?? 0,
        name: json['name'] as String? ?? '',
        types: (json['types'] as List? ?? const [])
            .map((e) => Speed30Type.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  /// Value expected by `quick_estimate`'s `transaction_type` param.
  String get transactionType => id == 2 ? 'rent' : 'sale';
}

/// `/api/valuation/v1/quick_estimate` result (no persistence).
class QuickEstimate {
  final double pricePerSqm;
  final double avg;
  final double min;
  final double max;
  final double confidence; // 0..1
  final String source;
  final String category;
  final bool communeUsed;

  const QuickEstimate({
    this.pricePerSqm = 0,
    this.avg = 0,
    this.min = 0,
    this.max = 0,
    this.confidence = 0,
    this.source = '',
    this.category = '',
    this.communeUsed = false,
  });

  factory QuickEstimate.fromJson(Map<String, dynamic> json) => QuickEstimate(
        pricePerSqm: _d(json['psqm']),
        avg: _d(json['avg']),
        min: _d(json['min']),
        max: _d(json['max']),
        confidence: _d(json['confidence']),
        source: json['source'] as String? ?? '',
        category: json['category'] as String? ?? '',
        communeUsed: json['commune_used'] == true,
      );

  static double _d(dynamic v) => v is num ? v.toDouble() : 0;
}
