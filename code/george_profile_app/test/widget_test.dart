// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:george_profile_app/main.dart';

void main() {
  testWidgets('home screen shows profile information and navigation buttons', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Raihan Ahmed'), findsOneWidget);
    expect(find.text('My hobbies'), findsOneWidget);
    expect(find.text('My favorite pics'), findsOneWidget);
    expect(find.text('Atlanta, GA, USA'), findsOneWidget);
  });

  testWidgets('tapping favorite pics button navigates to favorites screen', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('My favorite pics'));
    await tester.pumpAndSettle();

    expect(find.text('Favorite Pics'), findsOneWidget);
  });
}
