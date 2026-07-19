/// A single node in the property category tree returned by
/// `POST /api/valuation/v1/categories`.
///
/// The tree is 3 levels deep:
///   Level 1 (parentId == null) — transaction type: Sale / Rent / Holiday renting
///   Level 2 — property type:    Apartment / Land / Villa …
///   Level 3 — sub-type:         Buildable / Promotional … (optional refinement)
class ValuationCategory {
  final int id;
  final String name;
  final int? parentId;

  const ValuationCategory({
    required this.id,
    required this.name,
    this.parentId,
  });

  factory ValuationCategory.fromJson(Map<String, dynamic> json) {
    // parent_id can arrive as int, [int, "name"], false, or null.
    final raw = json['parent_id'];
    int? pid;
    if (raw is int) {
      pid = raw;
    } else if (raw is List && raw.isNotEmpty && raw[0] is int) {
      pid = raw[0] as int;
    }

    return ValuationCategory(
      id: json['id'] as int,
      name: (json['name'] ?? json['label'] ?? '') as String,
      parentId: pid,
    );
  }
}
