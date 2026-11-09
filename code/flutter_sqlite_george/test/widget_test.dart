// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_sqlite_george/main.dart';

void main() {
  testWidgets('home screen shows product actions', (WidgetTester tester) async {
    ProductDatabase.isAvailable = true;

    await tester.pumpWidget(const MyApp());

    expect(find.text('George SQLite App'), findsOneWidget);
    expect(find.text('Create Product'), findsWidgets);
    expect(find.text('View Product List'), findsWidgets);
  });
}
