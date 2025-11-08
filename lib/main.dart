import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'core/config/firebase_options.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/auth/register_page.dart';
import 'presentation/pages/home/feed_page.dart';
import 'presentation/pages/upload/upload_video_page.dart';
import 'presentation/pages/search/search_users_page.dart';
import 'presentation/pages/profile/profile_page.dart';
import 'presentation/pages/settings/settings_page.dart';
import 'presentation/pages/catalog/catalog_page.dart';
import 'core/providers/auth_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: GameTrackApp(),
    ),
  );
}

class GameTrackApp extends ConsumerWidget {
  const GameTrackApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'GameTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Colors.purple,
          secondary: Colors.blue,
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
      locale: const Locale('pt', 'BR'),
      home: authState.when(
        data: (user) => user != null ? const FeedPage() : const LoginPage(),
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (_, __) => const LoginPage(),
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const FeedPage(),
        '/upload': (context) => const UploadVideoPage(),
        '/search': (context) => const SearchUsersPage(),
        '/profile': (context) {
          final userId = ModalRoute.of(context)?.settings.arguments as String?;
          return ProfilePage(userId: userId);
        },
        '/settings': (context) => const SettingsPage(),
        '/catalog': (context) => const CatalogPage(),
      },
    );
  }
}
