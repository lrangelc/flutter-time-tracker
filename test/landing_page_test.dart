import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_time_tracker/app/home/home_page.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_time_tracker/app/sign_in/sign_in_page.dart';
import 'package:flutter_time_tracker/app/landing_page.dart';
import 'package:flutter_time_tracker/services/auth.dart';
import 'mocks.dart';

void main() {
  MockAuth mockAuth;
  StreamController<User> onAuthStateChangedController;

  setUp(() {
    mockAuth = MockAuth();
    onAuthStateChangedController = StreamController<User>();
  });

  tearDown(() {
    onAuthStateChangedController.close();
  });

  Future<void> pumpLandignPage(WidgetTester tester) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
        create: (_) => mockAuth,
        child: MaterialApp(
          home: Scaffold(
            body: Scaffold(
              body: LandingPage(),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  void stubOnAuthStateChangeYields(Iterable<User> onAuthStageChanged) {
    onAuthStateChangedController
        .addStream(Stream<User>.fromIterable(onAuthStageChanged));
    when(mockAuth.onAuthStateChanged).thenAnswer((_) {
      return onAuthStateChangedController.stream;
    });
  }

  testWidgets('stream waiting', (WidgetTester tester) async {
    stubOnAuthStateChangeYields([]);
    await pumpLandignPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('null user', (WidgetTester tester) async {
    stubOnAuthStateChangeYields([null]);
    await pumpLandignPage(tester);

    expect(find.byType(SignInPage), findsOneWidget);
  });

  testWidgets('non-null user', (WidgetTester tester) async {
    stubOnAuthStateChangeYields([User(uid: '123')]);
    await pumpLandignPage(tester);

    expect(find.byType(HomePage), findsOneWidget);
  });
}
