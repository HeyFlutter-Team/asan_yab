import 'dart:async';

import 'package:asan_yab/database/favorite_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/kcolors.dart';
import '../providers/categories_provider.dart';
import '../providers/places_provider.dart';
import '../widgets/new_places.dart';
import '../widgets/categories.dart';
import '../widgets/favorites.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import '../widgets/custom_search_bar.dart';
import 'category_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    onRefresh();
    startStremaing();
  }

  late ConnectivityResult connectivityResult;
  late StreamSubscription subscription;
  bool isConnected = true;
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

  Future<void> onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   Provider.of<CategoriesProvider>(context, listen: false).getCategories();
    //   Provider.of<PlaceProvider>(context, listen: false).getplaces();
    // });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0.0,
        title: const CustomSearchBar(),
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              NewPlaces(onRefresh: onRefresh),
              const SizedBox(height: 32),
              isConnected ? Categories(onRefresh: onRefresh) : const SizedBox(),
              Favorites(isConnected: isConnected),
            ],
          ),
        ),
      ),
    );
  }
}
