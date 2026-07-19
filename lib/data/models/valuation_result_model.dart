/// Parsed response from `POST /api/valuation/v1/submit`.
class ValuationResult {
  final int valuationId;
  final String refName;
  final String? reportUrl;
  final ValuationEstimation estimation;
  final ValuationDgi dgi;
  final ValuationConsensus consensus;
  final bool marketAvailable;

  const ValuationResult({
    required this.valuationId,
    required this.refName,
    required this.reportUrl,
    required this.estimation,
    required this.dgi,
    required this.consensus,
    required this.marketAvailable,
  });

  factory ValuationResult.fromJson(Map<String, dynamic> json) {
    final market = json['market'] as Map<String, dynamic>? ?? {};
    return ValuationResult(
      valuationId: json['valuation_id'] as int,
      refName: (json['name'] ?? '') as String,
      reportUrl: json['report_url'] as String?,
      estimation: ValuationEstimation.fromJson(
          json['estimation'] as Map<String, dynamic>? ?? {}),
      dgi: ValuationDgi.fromJson(json['dgi'] as Map<String, dynamic>? ?? {}),
      consensus: ValuationConsensus.fromJson(
          json['consensus'] as Map<String, dynamic>? ?? {}),
      marketAvailable: market['available'] == true,
    );
  }
}

class ValuationEstimation {
  final double min;
  final double avg;
  final double max;
  final double pricePerSqm;
  final double confidence;

  const ValuationEstimation({
    required this.min,
    required this.avg,
    required this.max,
    required this.pricePerSqm,
    required this.confidence,
  });

  factory ValuationEstimation.fromJson(Map<String, dynamic> json) =>
      ValuationEstimation(
        min: (json['min'] as num? ?? 0).toDouble(),
        avg: (json['avg'] as num? ?? 0).toDouble(),
        max: (json['max'] as num? ?? 0).toDouble(),
        pricePerSqm: (json['price_per_sqm'] as num? ?? 0).toDouble(),
        confidence: (json['confidence'] as num? ?? 0).toDouble(),
      );
}

class ValuationDgi {
  final String fiscalRisk; // "safe" | "risk" | "unknown"
  final String message;
  final double minPricePerSqm;
  final double minValueTotal;
  final String matchQuality; // "commune" | "wilaya"
  final String periodName;

  bool get isSafe => fiscalRisk == 'safe';

  const ValuationDgi({
    required this.fiscalRisk,
    required this.message,
    required this.minPricePerSqm,
    required this.minValueTotal,
    required this.matchQuality,
    required this.periodName,
  });

  factory ValuationDgi.fromJson(Map<String, dynamic> json) => ValuationDgi(
        fiscalRisk: (json['fiscal_risk'] ?? 'unknown') as String,
        message: (json['fiscal_risk_message'] ?? '') as String,
        minPricePerSqm: (json['min_price_per_sqm'] as num? ?? 0).toDouble(),
        minValueTotal: (json['min_value_total'] as num? ?? 0).toDouble(),
        matchQuality: (json['match_quality'] ?? 'wilaya') as String,
        periodName: (json['period_name'] ?? '') as String,
      );
}

class ValuationProvider {
  final String source;
  final String label;
  final String colorHex;
  final int m2;
  final double total;
  final int confidencePct;

  const ValuationProvider({
    required this.source,
    required this.label,
    required this.colorHex,
    required this.m2,
    required this.total,
    required this.confidencePct,
  });

  factory ValuationProvider.fromJson(Map<String, dynamic> json) =>
      ValuationProvider(
        source: (json['source'] ?? '') as String,
        label: (json['label'] ?? json['name'] ?? '') as String,
        colorHex: (json['color'] ?? '#7F00FD') as String,
        m2: (json['m2'] as num? ?? 0).toInt(),
        total: (json['total'] as num? ?? 0).toDouble(),
        confidencePct: (json['confidence_pct'] as num? ?? 0).toInt(),
      );
}

class ValuationConsensus {
  final bool hasData;
  final int m2;
  final double total;
  final double spreadPct;
  final String levelKey; // "high_consensus" | "medium_consensus" | ...
  final List<ValuationProvider> providers;

  String get levelLabel {
    if (levelKey.contains('high')) return 'Consensus fort';
    if (levelKey.contains('medium')) return 'Consensus moyen';
    return 'Consensus faible';
  }

  const ValuationConsensus({
    required this.hasData,
    required this.m2,
    required this.total,
    required this.spreadPct,
    required this.levelKey,
    required this.providers,
  });

  factory ValuationConsensus.fromJson(Map<String, dynamic> json) {
    final cmap = json['consensus'] as Map<String, dynamic>? ?? {};
    return ValuationConsensus(
      hasData: json['has_data'] == true,
      m2: (cmap['m2'] as num? ?? 0).toInt(),
      total: (cmap['total'] as num? ?? 0).toDouble(),
      spreadPct: (cmap['spread_pct'] as num? ?? 0).toDouble(),
      levelKey: (cmap['label_key'] ?? 'low') as String,
      providers: (json['providers'] as List? ?? [])
          .map((p) =>
              ValuationProvider.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }
}
