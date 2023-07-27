import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/kcolors.dart';
import '../widgets/new_places.dart';
import '../widgets/categories.dart';
import '../widgets/favorites.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
      showDialogBox();
    }
    setState(() {});
  }

  void showDialogBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              elevation: 10,
              icon: const Icon(Icons.wifi_off),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(20)),
              title: const Text('!انترنیت وجود ندارد'),
              content: const Text('لطفآ به انترنیت وصل شوید؟'),
              actions: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    checkInternet();
                  },
                  child: const Text('دوباره سعی کن '),
                )
              ],
            ));
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
