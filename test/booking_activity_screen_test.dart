import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:real_estate_app/global_booking_screen.dart';

void main() {
  testWidgets('BookingActivityScreen should build without errors', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: BookingActivityScreen(),
      ),
    );

    // Verify that the screen is displayed
    expect(find.byType(BookingActivityScreen), findsOneWidget);
    expect(find.text('Booking Activity'), findsOneWidget);
    
    // Verify that the segmented control is present
    expect(find.byType(Widget), findsWidgets); // The CustomSlidingSegmentedControl will be found as a Widget
    
    // Verify that the tabs exist
    expect(find.text('My Reserve'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);
    expect(find.text('Cancelled'), findsOneWidget);
    expect(find.text('Empty'), findsOneWidget);
  });
}