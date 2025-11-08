import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:game_track/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('login flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // TODO: Implementar testes de integração
      expect(find.text('Login'), findsOneWidget);
    });
  });
}

