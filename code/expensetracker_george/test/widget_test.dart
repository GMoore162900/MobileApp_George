import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localstorage/localstorage.dart';

import 'package:expensetracker_george/main.dart';

void main() {
  testWidgets('Expense tracker app loads with the expected home screen', (WidgetTester tester) async {
    await initLocalStorage();
    await localStorage.ready;
    localStorage.clear();

    await tester.pumpWidget(MyApp(localStorage: localStorage));

    expect(find.text('Expense Tracker'), findsOneWidget);
    expect(find.text('All Entries'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
