import 'package:latlong2/latlong.dart';

/// Approximate centroid (chef-lieu) coordinates for Algeria's 58 wilayas.
///
/// Listings carry only a wilaya name (no per-property lat/lng), so the map
/// places each listing at its wilaya centroid. Keys are normalized via
/// [_normalize] so lookups are accent/case/punctuation-insensitive.
class WilayaCoordinates {
  WilayaCoordinates._();

  /// Geographic center of Algeria — used to frame the initial map view.
  static const LatLng algeriaCenter = LatLng(28.0339, 1.6596);

  /// Resolves a wilaya name (e.g. "Alger", "Béjaïa", "Alger (DZ)") to a point.
  /// Returns null when unknown (e.g. listings located abroad).
  static LatLng? of(String wilayaName) => _byName[_normalize(wilayaName)];

  static String _normalize(String s) {
    var out = s.toLowerCase().trim();
    // Drop a trailing country marker like " (dz)".
    out = out.replaceAll(RegExp(r'\(.*?\)'), ' ');
    const accents = {
      'à': 'a', 'â': 'a', 'ä': 'a', 'á': 'a',
      'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e',
      'î': 'i', 'ï': 'i', 'í': 'i',
      'ô': 'o', 'ö': 'o', 'ó': 'o',
      'û': 'u', 'ü': 'u', 'ù': 'u',
      'ç': 'c',
    };
    final buf = StringBuffer();
    for (final ch in out.split('')) {
      buf.write(accents[ch] ?? ch);
    }
    out = buf.toString();
    // Keep only letters and spaces, collapse whitespace.
    out = out.replaceAll(RegExp(r'[^a-z ]'), ' ');
    out = out.replaceAll(RegExp(r'\s+'), ' ').trim();
    return out;
  }

  static final Map<String, LatLng> _byName = {
    for (final e in _raw.entries) _normalize(e.key): e.value,
  };

  static const Map<String, LatLng> _raw = {
    'Adrar': LatLng(27.8742, -0.2939),
    'Chlef': LatLng(36.1647, 1.3317),
    'Laghouat': LatLng(33.8000, 2.8650),
    'Oum El Bouaghi': LatLng(35.8775, 7.1135),
    'Batna': LatLng(35.5550, 6.1741),
    'Béjaïa': LatLng(36.7509, 5.0567),
    'Biskra': LatLng(34.8500, 5.7333),
    'Béchar': LatLng(31.6177, -2.2286),
    'Blida': LatLng(36.4703, 2.8277),
    'Bouira': LatLng(36.3736, 3.9020),
    'Tamanrasset': LatLng(22.7850, 5.5228),
    'Tébessa': LatLng(35.4042, 8.1242),
    'Tlemcen': LatLng(34.8783, -1.3150),
    'Tiaret': LatLng(35.3711, 1.3170),
    'Tizi Ouzou': LatLng(36.7169, 4.0497),
    'Alger': LatLng(36.7538, 3.0588),
    'Djelfa': LatLng(34.6703, 3.2630),
    'Jijel': LatLng(36.8190, 5.7667),
    'Sétif': LatLng(36.1898, 5.4108),
    'Saïda': LatLng(34.8303, 0.1517),
    'Skikda': LatLng(36.8761, 6.9094),
    'Sidi Bel Abbès': LatLng(35.1878, -0.6308),
    'Annaba': LatLng(36.9000, 7.7667),
    'Guelma': LatLng(36.4625, 7.4263),
    'Constantine': LatLng(36.3650, 6.6147),
    'Médéa': LatLng(36.2675, 2.7500),
    'Mostaganem': LatLng(35.9311, 0.0892),
    "M'Sila": LatLng(35.7058, 4.5419),
    'Mascara': LatLng(35.3968, 0.1400),
    'Ouargla': LatLng(31.9493, 5.3250),
    'Oran': LatLng(35.6969, -0.6331),
    'El Bayadh': LatLng(33.6800, 1.0200),
    'Illizi': LatLng(26.4833, 8.4667),
    'Bordj Bou Arréridj': LatLng(36.0731, 4.7608),
    'Boumerdès': LatLng(36.7660, 3.4772),
    'El Tarf': LatLng(36.7672, 8.3139),
    'Tindouf': LatLng(27.6711, -8.1475),
    'Tissemsilt': LatLng(35.6072, 1.8106),
    'El Oued': LatLng(33.3683, 6.8517),
    'Khenchela': LatLng(35.4361, 7.1436),
    'Souk Ahras': LatLng(36.2864, 7.9514),
    'Tipaza': LatLng(36.5894, 2.4475),
    'Mila': LatLng(36.4503, 6.2647),
    'Aïn Defla': LatLng(36.2639, 1.9678),
    'Naâma': LatLng(33.2667, -0.3128),
    'Aïn Témouchent': LatLng(35.2986, -1.1400),
    'Ghardaïa': LatLng(32.4911, 3.6736),
    'Relizane': LatLng(35.7372, 0.5558),
    "El M'Ghair": LatLng(33.9540, 5.9220),
    'El Meniaa': LatLng(30.5833, 2.8833),
    'Ouled Djellal': LatLng(34.4167, 5.0667),
    'Bordj Badji Mokhtar': LatLng(21.3167, 0.9500),
    'Béni Abbès': LatLng(30.1300, -2.1650),
    'Timimoun': LatLng(29.2639, 0.2306),
    'Touggourt': LatLng(33.1000, 6.0667),
    'Djanet': LatLng(24.5542, 9.4839),
    'In Salah': LatLng(27.1936, 2.4608),
    'In Guezzam': LatLng(19.5686, 5.7722),
  };
}
