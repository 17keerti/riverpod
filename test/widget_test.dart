// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:book_club_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BookClubApp());

    // Allow any async initialization (like the Bloc's initial load) to complete.
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Verify that the home page is shown (AppBar title)
    expect(find.text('Book Club Home'), findsOneWidget);
  });
}
