import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_time_tracker/app/sign_in/validators.dart';

void main() {
  test('non empy string', () {
    final validator = NonEmptyStringValidator();
    expect(validator.isValid('test'), true);
  });

  test('empy string', () {
    final validator = NonEmptyStringValidator();
    expect(validator.isValid(''), false);
  });

  test('null string', () {
    final validator = NonEmptyStringValidator();
    expect(validator.isValid(null), false);
  });
}
