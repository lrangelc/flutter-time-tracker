import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_time_tracker/app/home/job_entries/format.dart';

void main() {
  group('hours', () {
    test('positive', () {
      expect(Format.hours(10), '10h');
    });
    test('zero', () {
      expect(Format.hours(0), '0h');
    });
    test('negative', () {
      expect(Format.hours(-5), '0h');
    });

    test('decimal', () {
      expect(Format.hours(4.5), '4.5h');
    });
  });

  group('date', () {
    setUp(() async {
      // Intl.defaultLocale = 'en_GB';
      // await initializeDateFormatting('en_GB', null);
    });
    test('2020-08-12', () {
      expect(Format.date(DateTime(2020, 8, 12)), 'Aug 12, 2020');
    });
    test('2020-08-16', () {
      expect(Format.date(DateTime(2020, 8, 16)), 'Aug 16, 2020');
    });
  });

  group('dayOfWeek', () {
    setUp(() async {
      // Intl.defaultLocale = 'en_GB';
      // await initializeDateFormatting('en_GB', null);
    });
    test('Monday', () {
      expect(Format.dayOfWeek(DateTime(2020, 8, 10)), 'Mon');
    });
  });

  group('currency', () {
    test('positive', () {
      expect(Format.currency(10), '\$10');
    });
  });
}
