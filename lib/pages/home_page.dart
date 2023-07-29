import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
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
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'دسته بندی ها',
                  style: TextStyle(color: kSecodaryColor, fontSize: 20.0),
                ),
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CategoryPage()),
                  ),
                  icon: Icon(
                    Icons.arrow_circle_left_outlined,
                    size: 32.0,
                    color: kSecodaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          const Categories(),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 12.0),
            child: Text(
              'موارد دلخواه',
              style: TextStyle(color: kSecodaryColor, fontSize: 20.0),
            ),
          ),
          Favorites(isConnected: isConnective),
        ],
      ),
    );
  }
}
