/// A selectable value within a form attribute.
class FormSchemaValue {
  final int id;
  final String name;
  final double impactPct;
  final String impactNote;

  const FormSchemaValue({
    required this.id,
    required this.name,
    required this.impactPct,
    required this.impactNote,
  });

  factory FormSchemaValue.fromJson(Map<String, dynamic> json) =>
      FormSchemaValue(
        id: json['id'] as int,
        name: (json['name'] ?? '') as String,
        impactPct: (json['impact_pct'] as num?)?.toDouble() ?? 0.0,
        impactNote: json['impact_note'] is String
            ? json['impact_note'] as String
            : '',
      );
}

/// A single attribute (question) inside a form section.
/// [displayType] is one of: 'radio', 'radio_square', 'multi'.
class FormSchemaAttribute {
  final int ruleId;
  final int attributeId;
  final String name;
  final String displayType;
  final bool required;
  final String? helpText;
  final double impactWeight;
  final bool showImpact;
  final String? icon;
  final List<FormSchemaValue> values;

  const FormSchemaAttribute({
    required this.ruleId,
    required this.attributeId,
    required this.name,
    required this.displayType,
    required this.required,
    this.helpText,
    required this.impactWeight,
    required this.showImpact,
    this.icon,
    required this.values,
  });

  bool get isMulti => displayType == 'multi';

  factory FormSchemaAttribute.fromJson(Map<String, dynamic> json) {
    final vals = (json['values'] as List? ?? [])
        .map((v) => FormSchemaValue.fromJson(v as Map<String, dynamic>))
        .toList();
    return FormSchemaAttribute(
      ruleId: json['rule_id'] as int? ?? 0,
      attributeId: json['attribute_id'] as int? ?? 0,
      name: (json['name'] ?? '') as String,
      displayType: (json['display_type'] ?? 'radio') as String,
      required: json['required'] == true,
      helpText:
          json['help_text'] is String ? json['help_text'] as String : null,
      impactWeight: (json['impact_weight'] as num?)?.toDouble() ?? 0.0,
      showImpact: json['show_impact'] == true,
      icon: json['icon'] is String ? json['icon'] as String : null,
      values: vals,
    );
  }
}

/// A named section (accordion group) containing multiple attributes.
class FormSchemaSection {
  final String key;
  final String label;
  final List<FormSchemaAttribute> attributes;

  const FormSchemaSection({
    required this.key,
    required this.label,
    required this.attributes,
  });

  static String labelFromKey(String key) {
    const map = {
      'construction': 'Construction',
      'essential': 'Essentiel',
      'essentials': 'Essentiel',
      'financier': 'Documents & financement',
      'vue': 'Vue & exposition',
      'comfort': 'Confort intérieur',
      'location': 'Localisation',
      'surface': 'Surface & config',
      'equipments': 'Équipements',
      'floor': 'Étage & accès',
      'specifics': 'Spécificités DZ',
    };
    return map[key] ??
        key[0].toUpperCase() + key.substring(1).replaceAll('_', ' ');
  }
}
