import 'dart:typed_data';

import 'package:asan_yab/utils/convert_digits_to_farsi.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';

import '../database/favorite_provider.dart';

import '../providers/places_provider.dart';
import '../widgets/page_view_item.dart';
import 'detials_page_offline.dart';

class DetailsPage extends StatefulWidget {
  final String id;

  const DetailsPage({super.key, required this.id});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Int8List logo = Int8List(0);
  Int8List coverImage = Int8List(0);
  late bool isLoading = true;
  late bool toggle;
  Future<Int8List> downloadFile(String url) async {
    final bytes = (await NetworkAssetBundle(Uri.parse(url)).load(url))
        .buffer
        .asInt8List();
    return bytes;
  }

  Future<void> getImage(String urlLogo, String coverImage1) async {
    showDialogBox();
    logo = await downloadFile(urlLogo);
    coverImage = await downloadFile(coverImage1);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<FavoriteProvider>(context, listen: false);
      provider.toggle = provider.isExist(widget.id);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showDialogBox() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => SizedBox(
              height: 100,
              child: AlertDialog(
                elevation: 4,
                content: const Row(
                  children: [
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                          color: Colors.blueGrey, strokeWidth: 3.0),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'لطفا صبر کنید...',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(12)),
                // title: const Text('لطفا صبر کنید!'),
                // content: const Text('لطفآ به انترنیت وصل شوید؟'),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    List<String> phoneData = [];
    List<String> addressData = [];

    final size = MediaQuery.of(context).size;

    final provider = Provider.of<FavoriteProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: FutureBuilder(
          future: Provider.of<PlaceProvider>(context, listen: false)
              .fetchSinglePlace(widget.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  color: Colors.blueGrey,
                ),
              );
            } else if (snapshot.hasData) {
              final places = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 35),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back),
                          iconSize: 25,
                        ),
                        Consumer<FavoriteProvider>(
                          builder: (context, value, child) {
                            return IconButton(
                              onPressed: () {
                                if (!value.isExist(places!.id)) {
                                  getImage(places.logo, places.coverImage)
                                      .whenComplete(() {
                                    Navigator.pop(context);
                                    provider.toggleFavorite(
                                        places.id,
                                        places,
                                        addressData,
                                        phoneData,
                                        logo,
                                        coverImage);
                                  });
                                } else {
                                  provider.toggleFavorite(places.id, places,
                                      addressData, phoneData, logo, coverImage);
                                }
                              },
                              icon: value.toggle
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )
                                  : const Icon(Icons.favorite_border),
                              iconSize: 25,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 40, top: 12),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              const SizedBox(height: 10),
                              (places!.coverImage == '')
                                  ? const CircularProgressIndicator()
                                  : Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          imageUrl: places.coverImage,
                                          width: double.infinity,
                                          height: size.height * 0.31,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Image.asset(
                                            'assets/asan_yab.png',
                                          ),
                                        ),
                                      ),
                                    ),
                              const SizedBox(height: 20),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  '${places.name}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 12),
                              (places.description == '' ||
                                      places.description == null)
                                  ? const SizedBox()
                                  : CustomCard(
                                      title: 'توضیحات',
                                      child: Text(places.description!),
                                    ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: (places.gallery.isEmpty)
                                    ? const SizedBox()
                                    : const Row(
                                        children: [
                                          Icon(
                                            Icons.library_books,
                                            color: Colors.black54,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'گالری',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54),
                                          ),
                                          SizedBox(height: 12)
                                        ],
                                      ),
                              ),
                              places.gallery.isEmpty
                                  ? const SizedBox(height: 0)
                                  : SizedBox(
                                      height: size.height * 0.25,
                                      child: places.gallery.isEmpty
                                          ? const CircularProgressIndicator(
                                              color: Colors.blueGrey,
                                              strokeWidth: 3,
                                            )
                                          : ListView.builder(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              scrollDirection: Axis.horizontal,
                                              itemCount: places.gallery.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 6,
                                                          left: 2,
                                                          right: 2,
                                                          bottom: 18),
                                                  child: PageViewItem(
                                                      selectedIndex: index,
                                                      gallery: places.gallery),
                                                );
                                              },
                                            ),
                                    ),
                              (places.adresses.isEmpty)
                                  ? const SizedBox()
                                  : CustomCard(
                                      title: 'مشخصات',
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: places.adresses.length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          phoneData.add(
                                              places.adresses[index].phone);
                                          addressData.add(
                                              places.adresses[index].address);
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: (places.adresses[index]
                                                        .address.isEmpty)
                                                    ? const SizedBox(height: 0)
                                                    : InkWell(
                                                        onTap: () async {
                                                          var uri = Uri.parse(
                                                              "google.navigation:q=${places.adresses[index].lat},${places.adresses[index].lang}&mode=d");
                                                          launchUrl(uri);
                                                        },
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Flexible(
                                                                child: Icon(Icons
                                                                    .location_on_outlined)),
                                                            const SizedBox(
                                                                width: 3),
                                                            Flexible(
                                                              child: Text(
                                                                '${places.adresses[index].address} ',
                                                                maxLines: 4,
                                                                overflow:
                                                                    TextOverflow
                                                                        .fade,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black54),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                              ),
                                              (places.adresses[index].phone
                                                      .isEmpty)
                                                  ? const SizedBox(height: 0)
                                                  : ConstrainedBox(
                                                      constraints:
                                                          const BoxConstraints(
                                                              minWidth: 120),
                                                      child: OutlinedButton(
                                                        style: OutlinedButton.styleFrom(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8)),
                                                        onPressed: () async {
                                                          await FlutterPhoneDirectCaller
                                                              .callNumber(
                                                            places
                                                                .adresses[index]
                                                                .phone,
                                                          );
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              convertDigitsToFarsi(
                                                                  places
                                                                      .adresses[
                                                                          index]
                                                                      .phone),
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black54,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 8),
                                                            const Icon(
                                                              Icons
                                                                  .phone_android_sharp,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const SizedBox();
            }
          }),
    );
  }
}
