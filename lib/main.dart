// ignore_for_file: prefer_const_literals_to_create_immutables, unused_import, depend_on_referenced_packages, prefer_const_constructors, deprecated_member_use

import 'package:easy_finder/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final TextStyle customTextStyle = TextStyle(
      fontFamily: 'Persian',
    );
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('fa')
        // Spanish
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.white,
        useMaterial3: true,
        textTheme: TextTheme(
          bodyText2: customTextStyle,
        ),
      ),
      home: const MainPage(),
    );
  }
}
