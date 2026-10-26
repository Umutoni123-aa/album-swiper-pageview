import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:album_swiper/main.dart';

void main() {
  testWidgets('shows the album PageView and live controls', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AlbumApp());

    expect(find.byType(PageView), findsOneWidget);
    expect(find.text('Horizontal'), findsOneWidget);
    expect(find.text('Vertical'), findsOneWidget);
    expect(find.text('1.0'), findsOneWidget);
    expect(find.text('0.8'), findsOneWidget);
    expect(find.text('On'), findsOneWidget);
    expect(find.text('Off'), findsOneWidget);
    expect(find.byType(ChoiceChip), findsNWidgets(6));
  });

  testWidgets('changes the scroll direction control', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AlbumApp());

    await tester.tap(find.text('Vertical'));
    await tester.pump();

    expect(find.byType(PageView), findsOneWidget);
  });
}
