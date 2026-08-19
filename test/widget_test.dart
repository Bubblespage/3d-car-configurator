import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sports_car_configurator/main.dart';

void main() {
  testWidgets('Configurator app loads test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: SportsCarConfiguratorApp()),
    );
    expect(find.byType(SportsCarConfiguratorApp), findsOneWidget);
  });
}
