/// Algerian wilaya (administrative province). Fetched from `/api/picker/wilayas`.
class Wilaya {
  final int id;
  final String name;
  final String code; // zero-padded, e.g. "16"

  const Wilaya({required this.id, required this.name, required this.code});

  factory Wilaya.fromJson(Map<String, dynamic> json) => Wilaya(
        id: json['id'] as int,
        name: json['name'] as String,
        // API returns unpadded codes ("1", "16"); pad to 2 digits.
        code: (json['code'] as String).padLeft(2, '0'),
      );

  String get display => '$code — $name';
}
