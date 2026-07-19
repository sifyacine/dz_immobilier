import 'package:flutter/material.dart';

class SimulationCategory {
  final int id;
  final String name;
  final String internalType;
  final String iconClass;

  const SimulationCategory({
    required this.id,
    required this.name,
    required this.internalType,
    required this.iconClass,
  });

  factory SimulationCategory.fromJson(Map<String, dynamic> json) {
    return SimulationCategory(
      id: json['id'] as int,
      name: json['name_translated'] as String,
      internalType: json['internal_type'] as String,
      iconClass: json['icon_class'] as String,
    );
  }

  IconData get icon {
    switch (iconClass) {
      case 'fa-building-o':
        return Icons.apartment;
      case 'fa-map-o':
        return Icons.landscape;
      case 'fa-home':
        return Icons.home;
      case 'fa-cubes':
        return Icons.layers;
      case 'fa-briefcase':
        return Icons.work;
      default:
        return Icons.home;
    }
  }
}
