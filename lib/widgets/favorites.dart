import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';
import '../constants/kcolors.dart';
import '../database/favorite_provider.dart';
import '../pages/detials_page.dart';
import '../pages/detials_page_offline.dart';
import '../utils/convert_digits_to_farsi.dart';

class Favorites extends StatefulWidget {
  final bool isConnected;
  const Favorites({super.key, required this.isConnected});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  void initState() {
    super.initState();
    Provider.of<FavoriteProvider>(context, listen: false).fetchUser();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Consumer<FavoriteProvider>(
      builder: (context, value, child) {
        return value.dataList.isEmpty
            ? const SizedBox()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0, top: 12.0),
                    child: Text(
                      'موارد دلخواه',
                      style: TextStyle(color: kSecodaryColor, fontSize: 20.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12.0,
                        crossAxisSpacing: 12.0,
                        mainAxisExtent: 230.0,
                      ),
                      itemCount: value.dataList.length,
                      itemBuilder: (context, index) {
                        final toggle =
                            value.dataList[index]['toggle'] == 1 ? true : false;
                        final items = value.dataList[index];
                        List<String> phoneData =
                            List<String>.from(jsonDecode(items['phone']));
                        final phoneNumber = convertDigitsToFarsi(phoneData[0]);
                        return Stack(
                          children: [
                            Card(
                              child: GestureDetector(
                                onTap: () {
                                  debugPrint(
                                      'Ramin check connectivity: ${widget.isConnected}');
                                  widget.isConnected
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailsPage(
                                                id: value.dataList[index]
                                                    ['id']),
                                          ))
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailPageOffline(
                                                    favItem:
                                                        value.dataList[index]),
                                          ));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: kPrimaryColor,
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: screenHeight * 0.15,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(12.0),
                                            topRight: Radius.circular(12.0),
                                          ),
                                          image: DecorationImage(
                                            image: MemoryImage(
                                                Uint8List.fromList(value
                                                    .dataList[index]['image'])),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(12.0),
                                              topRight: Radius.circular(12.0),
                                            ),
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Column(
                                          children: [
                                            Text(
                                              value.dataList[index]['name'],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16.0),
                                            ),
                                            OutlinedButton(
                                              onPressed: () async {
                                                await FlutterPhoneDirectCaller
                                                    .callNumber(phoneNumber);
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(phoneNumber,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14.0,
                                                      )),
                                                  const Icon(
                                                      Icons.phone_android,
                                                      color: Colors.green),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 10.0,
                              top: 10.0,
                              child: IconButton(
                                onPressed: () {
                                  value.delete(value.dataList[index]['id']);
                                },
                                icon: toggle
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 30.0,
                                      )
                                    : Icon(
                                        Icons.favorite_border,
                                        color: kPrimaryColor,
                                        size: 30.0,
                                      ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
      },
    );
  }
}
