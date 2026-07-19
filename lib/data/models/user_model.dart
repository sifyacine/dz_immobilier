/// Authenticated user. Stored in [StorageService] as a JSON map after login.
///
/// Field mapping from Odoo's `/web/session/authenticate` response:
///   uid         → uid
///   partner_id  → partnerId
///   name        → name
///   username    → email  (Odoo calls the login field "username" in its response)
///   lang        → lang
///   tz          → tz
class User {
  final int uid;
  final int partnerId;
  final String name;
  final String email;
  final String phone;
  final String role; // 'user' | 'agent' | 'admin'
  final String lang; // Odoo locale, e.g. 'fr_FR'
  final String tz;   // Timezone, e.g. 'Africa/Algiers'

  const User({
    required this.uid,
    required this.partnerId,
    required this.name,
    required this.email,
    this.phone = '',
    this.role = 'user',
    this.lang = 'fr_FR',
    this.tz = 'Africa/Algiers',
  });

  /// Build from the Odoo `/web/session/authenticate` result object.
  factory User.fromOdooLogin(Map<String, dynamic> json) => User(
        uid: json['uid'] as int? ?? 0,
        partnerId: json['partner_id'] as int? ?? 0,
        name: json['name'] as String? ?? '',
        email: json['username'] as String? ?? '',
        lang: json['lang'] as String? ?? 'fr_FR',
        tz: json['tz'] as String? ?? 'Africa/Algiers',
      );

  /// Build from the locally stored JSON map (set on login, read on next launch).
  factory User.fromJson(Map<String, dynamic> json) => User(
        uid: json['uid'] as int? ?? 0,
        partnerId: json['partner_id'] as int? ?? 0,
        name: json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        role: json['role'] as String? ?? 'user',
        lang: json['lang'] as String? ?? 'fr_FR',
        tz: json['tz'] as String? ?? 'Africa/Algiers',
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'partner_id': partnerId,
        'name': name,
        'email': email,
        'phone': phone,
        'role': role,
        'lang': lang,
        'tz': tz,
      };
}
