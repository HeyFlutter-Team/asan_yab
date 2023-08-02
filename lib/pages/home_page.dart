import 'dart:async';
import 'package:asan_yab/database/favorite_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/kcolors.dart';
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
    startStremaing();
  }

  late ConnectivityResult connectivityResult;
  late StreamSubscription subscription;
  var isConnective = false;
  void checkInternet() async {
    connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      isConnective = true;
    } else {
      isConnective = false;
      showsSnackBar();
    }
    setState(() {});
  }

  void showsSnackBar() {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'انترنیت وصل نیت!',
        message: 'لطفا انترنیت را وصل کنید!',
        contentType: ContentType.failure,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0.0,
        title: const CustomSearchBar(),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 16.0),
          const NewPlaces(),
          const SizedBox(height: 16),
          const SizedBox(height: 16.0),
          const Categories(),
          Consumer<FavoriteProvider>(
            builder: (context, value, child) {
              return value.dataList.isEmpty
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(right: 16.0, top: 12.0),
                      child: Text(
                        'موارد دلخواه',
                        style: TextStyle(color: kSecodaryColor, fontSize: 20.0),
                      ),
                    );
            },
          ),
          Favorites(isConnected: isConnective),
        ],
      ),
    );
  }
}
