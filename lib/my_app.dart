import 'package:asan_yab/core/extensions/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/routes/route_config.dart';
import 'data/repositoris/language_repo.dart';
import 'data/repositoris/theme_Provider.dart';

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
  Widget build(BuildContext context) => ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp.router(
          routerConfig: RouteConfig.router(),
          themeMode: getCurrentThemeMode(),
          darkTheme: buildDarkTheme(),
          theme: buildLightTheme(),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale(ref.watch(languageProvider).code),
          builder: (context, child) => Theme(
            data: ThemeData(
              useMaterial3: true,
              brightness: Theme.of(context).brightness,
              fontFamily: 'Shabnam',
            ),
            child: child!,
          ),
        ),
      );

  ThemeMode getCurrentThemeMode() {
    final themeModel = ref.watch(themeModelProvider);
    return themeModel.currentThemeMode != ThemeMode.system
        ? themeModel.currentThemeMode
        : ThemeMode.light;
  }

  ThemeData buildDarkTheme() => ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.apply(bodyColor: Colors.white),
      );

  ThemeData buildLightTheme() => ThemeData.light().copyWith(
        textTheme: ThemeData.light().textTheme.apply(bodyColor: Colors.black),
      );
}
