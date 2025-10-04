import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fpl_assistant_app/main.dart';

void main() {
  testWidgets('Home renders navigation buttons', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    expect(find.text('FPL Assistant'), findsOneWidget);
    expect(find.text('Players'), findsOneWidget);
    expect(find.text('Watchlist'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}