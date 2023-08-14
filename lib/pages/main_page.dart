import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../pages/suggestion.dart';
import 'package:flutter/material.dart';

import 'about_us_page.dart';
import 'home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late ConnectivityResult connectivityResult;
  late StreamSubscription subscription;
  bool isConnected = true;
  @override
  void initState() {
    super.initState();
    startStremaing();
  }

  void checkInternet() async {
    connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none &&
        (isConnected == false)) {
      isConnected = true;
      showsSnackBarForConnect();
    } else if (connectivityResult != ConnectivityResult.none) {
      isConnected = true;
    } else {
      isConnected = false;
      showsSnackBarForDisconnect();
    }

    setState(() {});
  }

  void showsSnackBarForDisconnect() {
    final snackBar = SnackBar(
      duration: const Duration(days: 1),
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'انترنت وصل نیست!',
        message: 'لطفا انترنیت را وصل کنید!',
        contentType: ContentType.warning,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void showsSnackBarForConnect() {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 5),
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        message: 'از برنامه لذت ببرید!',
        contentType: ContentType.success,
        title: 'انترنت وصل است',
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void startStremaing() {
    subscription = Connectivity().onConnectivityChanged.listen((event) {
      checkInternet();
    });
  }

  int selectedIndex = 0;

  final pages = [const HomePage(), const SuggestionPage(), const AboutUsPage()];
  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      bottomNavigationBar: buildBottomNavigationBar(),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          HomePage(isConnected: isConnected),
          const SuggestionPage(),
          const AboutUsPage()
        ],
      ),
    );
  }

  Widget buildBottomNavigationBar() => BottomNavigationBar(
        selectedFontSize: 20.0,
        unselectedFontSize: 16.0,
        currentIndex: selectedIndex,
        selectedItemColor: Colors.red,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          FocusScope.of(context).unfocus();
          setState(() => selectedIndex = index);
        },
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            label: 'خانه',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: ' مکان جدید',
            icon: Icon(Icons.place),
          ),
          BottomNavigationBarItem(
            label: 'در باره ما',
            icon: Icon(Icons.person),
          ),
        ],
      );
}
