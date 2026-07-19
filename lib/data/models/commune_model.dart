/// Algerian commune (sub-division of a wilaya). Fetched from `/api/picker/communes?wilaya_id=`.
class Commune {
  final int id;
  final String name;
  final int wilayaId;

  const Commune({required this.id, required this.name, required this.wilayaId});

  factory Commune.fromJson(Map<String, dynamic> json) => Commune(
        id: json['id'] as int,
        name: json['name'] as String,
        // Odoo may expose the wilaya FK as 'wilaya_id' or 'state_id'.
        wilayaId: (json['wilaya_id'] ?? json['state_id'] ?? 0) as int,
      );
}
