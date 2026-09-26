import 'package:flutter_test/flutter_test.dart';

import 'package:go_route_george/main.dart';

void main() {
  testWidgets('home screen shows navigation buttons and lifecycle status', (tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Go to About'), findsOneWidget);
    expect(find.text('Go to Details (ID: 42)'), findsOneWidget);
    expect(find.textContaining('App status:'), findsOneWidget);
  });

  testWidgets('navigates to the about screen', (tester) async {
    await tester.pumpWidget(MyApp());

    await tester.tap(find.text('Go to About'));
    await tester.pumpAndSettle();

    expect(find.text('About'), findsOneWidget);
    expect(find.text('Back'), findsOneWidget);
  });

  testWidgets('navigates to the details screen with the parameter', (tester) async {
    await tester.pumpWidget(MyApp());

    await tester.tap(find.text('Go to Details (ID: 42)'));
    await tester.pumpAndSettle();

    expect(find.text('Details 42'), findsOneWidget);
    expect(find.text('Back'), findsOneWidget);
  });
}
