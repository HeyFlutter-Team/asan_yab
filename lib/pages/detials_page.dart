import 'dart:typed_data';

import 'package:asan_yab/providers/lazy_loading_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'package:provider/provider.dart';

import '../database/favorite_provider.dart';
// import '../database/firebase_helper/place.dart';

import '../widgets/page_view_iten.dart';
import 'detials_page_offline.dart';

class DetailsPage extends StatefulWidget {
  final String id;

  const DetailsPage({
    super.key,
    required this.id,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final _pageViewController = PageController(viewportFraction: 0.27);
  late Int8List logo;
  late Int8List coverImage;
  late bool isLoading = true;
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
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  void showDialogBox() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              elevation: 10,
              icon: const Icon(Icons.favorite_sharp),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(20)),
              title: const Text('لطفا صبر کنید!'),
              // content: const Text('لطفآ به انترنیت وصل شوید؟'),
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
          future: Provider.of<LazyLoadingProvider>(context, listen: false)
              .fetchSinglePlace(widget.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 200),
                  child: Text(
                    '........Loading',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              );
            } else if (snapshot.hasData) {
              final places = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
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
                                if (!value.isExist(places.id)) {
                                  getImage(places.logo!, places.coverImage)
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
                              icon: value.isExist(places!.id)
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
                                  ? const CircularProgressIndicator(): Container(
                                width: size.width * 0.93,
                                height: size.height * 0.31,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 0.22,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          places.coverImage)),
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
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: (places.gallery == [] ||
                                    places.description == null)
                                    ? const SizedBox():const Row(
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
                              SizedBox(
                                height: size.height * 0.25,
                                child: PageView.builder(
                                  controller: _pageViewController,
                                  itemCount: places.gallery.length,
                                  padEnds: false,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
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
                              (places.adresses == [] ||
                                  places.description == null)
                                  ? const SizedBox(): CustomCard(
                                title: 'مشخصات',
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: places.adresses.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    phoneData.add(places.adresses[index].phone);
                                    addressData
                                        .add(places.adresses[index].address);
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Flexible(
                                                    child: Icon(Icons
                                                        .location_on_outlined)),
                                                const SizedBox(
                                                  width: 3,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                      '${places.adresses[index].address} ',
                                                      maxLines: 4,
                                                      overflow:
                                                          TextOverflow.fade,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Colors.black54)),
                                                ),
                                              ],
                                            )),
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(
                                              minWidth: 120),
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8)),
                                            onPressed: () async {
                                              await FlutterPhoneDirectCaller
                                                  .callNumber(
                                                places.adresses[index].phone,
                                              );
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                    places
                                                        .adresses[index].phone,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black54)),
                                                const SizedBox(width: 8),
                                                const Icon(
                                                  Icons.phone_android_sharp,
                                                  color: Colors.green,
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
