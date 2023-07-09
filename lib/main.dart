// ignore_for_file: prefer_const_literals_to_create_immutables, unused_import, depend_on_referenced_packages, prefer_const_constructors, deprecated_member_use
import 'package:easy_finder/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final customTextStyle = TextStyle(fontFamily: 'Persion');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [const Locale('fa')],
      theme: ThemeData(
        colorSchemeSeed: Colors.white,
        useMaterial3: true,
        textTheme: TextTheme(bodyMedium: customTextStyle),
      ),
      home: const MainPage(),
    );
  }
}
