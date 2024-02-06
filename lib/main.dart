import 'package:asan_yab/data/repositoris/language_repository.dart';
import 'package:asan_yab/presentation/pages/main_page.dart';
import 'package:asan_yab/presentation/pages/themeProvider.dart';
import 'package:asan_yab/presentation/pages/verify_email_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'data/models/language.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.data['id']}');
}

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  final language =
      await container.read(languageRepositoryProvider).getLanguage();
  await Future.delayed(const Duration(seconds: 2));
  FlutterNativeSplash.remove();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAnalytics.instance
      .setAnalyticsCollectionEnabled(true); //firebase analytics
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  //firebase messegaing

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  //
  // FirebaseFirestore.instance.useFirestoreEmulator('host', '');

  runApp(ProviderScope(
    overrides: [languageProvider.overrideWith((ref) => language)],
    child: const MyApp(),
  ));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    ref.read(themeModelProvider.notifier).initialize().whenComplete(
        () => ref.read(themeModelProvider.notifier).loadSavedTheme());
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = ref.watch(themeModelProvider);
    final language = ref.watch(languageProvider);
    return MaterialApp(
      navigatorKey: navigatorKey,
      themeMode: themeModel.currentThemeMode,
      darkTheme: ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: Colors.white,
            ),
      ),
      theme: ThemeData.light().copyWith(
        textTheme: ThemeData.light().textTheme.apply(
              bodyColor: Colors.black,
            ),
      ),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(language.code),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('خطا در اتصال'),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            final user = snapshot.data!;
            if (user.emailVerified) {
              return const MainPage();
            } else {
              return VerifyEmailPage(
                email: user.email,
              );
            }
          } else {
            return const MainPage();
          }
        },
      ),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            useMaterial3: true,
            brightness: Theme.of(context).brightness,
            fontFamily: 'Shabnam',
            // appBarTheme: AppBarTheme(

            // Add other theme configurations here if needed
          ),
          child: child!,
        );
      },
    );
  }
}
