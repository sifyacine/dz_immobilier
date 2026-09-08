// Unit tests for the foundational data model and form validators.

import 'package:dz_immobilier/data/models/property_model.dart';
import 'package:dz_immobilier/shared/helpers/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Property.fromJson', () {
    test('parses a full payload', () {
      final p = Property.fromJson({
        'id': 7,
        'title': 'Villa Oran',
        'price': 65000000,
        'type': 'rent',
        'images': ['a.jpg', 'b.jpg'],
        'is_featured': true,
      });

      expect(p.id, 7);
      expect(p.title, 'Villa Oran');
      expect(p.price, 65000000);
      expect(p.isRent, isTrue);
      expect(p.thumbnail, 'a.jpg');
      expect(p.isFeatured, isTrue);
    });

    test('falls back to defaults on a sparse payload', () {
      final p = Property.fromJson({});
      expect(p.id, 0);
      expect(p.currency, 'DZD');
      expect(p.type, 'sale');
      expect(p.images, isEmpty);
      expect(p.thumbnail, isNull);
    });
  });

  group('Validators', () {
    test('email', () {
      expect(Validators.email('foo@bar.com'), isNull);
      expect(Validators.email('not-an-email'), isNotNull);
    });

    test('Algerian phone', () {
      expect(Validators.phone('0551234567'), isNull);
      expect(Validators.phone('0212345678'), isNotNull); // wrong prefix
      expect(Validators.phone('123'), isNotNull);
    });

    test('password length', () {
      expect(Validators.password('12345678'), isNull);
      expect(Validators.password('123'), isNotNull);
    });
  });
}
