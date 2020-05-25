import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'mocks.dart';

import 'package:flutter_time_tracker/services/auth.dart';
import 'package:flutter_time_tracker/app/sign_in/sign_in_manager.dart';

class MockValueNotifier<T> extends ValueNotifier<T> {
  MockValueNotifier(T value) : super(value);

  List<T> values = [];

  @override
  set value(T newValue) {
    values.add(newValue);
    super.value = newValue;
  }
}

void main() {
  MockAuth mockAuth;
  MockValueNotifier<bool> isLoading;
  SignInManager manager;

  setUp(() {
    mockAuth = MockAuth();
    isLoading = MockValueNotifier<bool>(false);
    manager = SignInManager(auth: mockAuth, isLoading: isLoading);
  });

  test('sign-in - success', () async {
    when(mockAuth.signInAnonymously())
        .thenAnswer((_) => Future.value(User(uid: '123')));
    await manager.signInAnonymously();

    expect(isLoading.values, [true]);
  });

  test('sign-in - failure', () async {
    when(mockAuth.signInAnonymously())
        .thenThrow(PlatformException(code: 'ERROR', message: 'sign-in-failed'));
    try {
      await manager.signInAnonymously();
    } catch (err) {
      expect(isLoading.values, [true, false]);
    }
  });
}
