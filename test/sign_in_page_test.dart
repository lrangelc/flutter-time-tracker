import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_time_tracker/app/sign_in/sign_in_page.dart';
import 'package:flutter_time_tracker/services/auth.dart';
import 'mocks.dart';

void main() {
  MockAuth mockAuth;
  MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    mockAuth = MockAuth();
    mockNavigatorObserver = MockNavigatorObserver();
  });

  Future<void> pumpSignInPage(WidgetTester tester,
      {VoidCallback onSignedIn}) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
        create: (_) => mockAuth,
        child: MaterialApp(
          home: Scaffold(
            body: Scaffold(
              body: Builder(
                builder: (context) => SignInPage.create(context),
              ),
            ),
          ),
          navigatorObservers: [mockNavigatorObserver],
        ),
      ),
    );
    verify(mockNavigatorObserver.didPush(any, any)).called(1);
  }

  testWidgets('email and password navigation', (WidgetTester tester) async {
    await pumpSignInPage(tester);
    final emailSignInButton = find.byKey(SignInPage.emailPasswordKey);
    expect(emailSignInButton, findsOneWidget);

    await tester.tap(emailSignInButton);
    await tester.pumpAndSettle();

    verify(mockNavigatorObserver.didPush(any, any)).called(1);
  });
}
