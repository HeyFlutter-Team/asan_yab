import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'package:provider/provider.dart';

import '../database/favorite_provider.dart';
import '../database/firebase_helper/place.dart';

import '../widgets/page_view_iten.dart';
import 'detials_page_offline.dart';

class DetailsPage extends StatefulWidget {
  final Place places;

  const DetailsPage({
    super.key,
    required this.places,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final _pageViewController = PageController(viewportFraction: 0.27);
  late Int8List logo;
  late Int8List coverImage;
  late bool isLoading;
  Future<Int8List> downloadFile(String url) async {
    final bytes = (await NetworkAssetBundle(Uri.parse(url)).load(url))
        .buffer
        .asInt8List();
    return bytes;
  }

  Future<void> getImage() async {
    logo = await downloadFile(widget.places.logo!);
    coverImage = await downloadFile(widget.places.coverImage!);
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    getImage().whenComplete(() => setState(() {
          isLoading = false;
        }));
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> phoneData = [];
    List<String> addressData = [];
    final provider = Provider.of<FavoriteProvider>(context, listen: false);

    final size = MediaQuery.of(context).size;

    debugPrint("Mahdi: coverImage: ${widget.places.coverImage}");

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                            onPressed: () async {
                              provider.toggleFavorite(
                                  widget.places.id,
                                  widget.places,
                                  addressData,
                                  phoneData,
                                  logo,
                                  coverImage);
                            },
                            icon: value.isExist(widget.places.id)
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
                    child: Column(
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            Container(
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
                                    fit: BoxFit.fitWidth,
                                    image: NetworkImage(
                                        '${widget.places.coverImage}')),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                '${widget.places.name}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 12),
                            CustomCard(
                              title: 'توضیحات',
                              child: Text(widget.places.description!),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
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
                                itemCount: widget.places.gallery.length,
                                padEnds: false,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 6, left: 2, right: 2, bottom: 18),
                                    child: PageViewItem(
                                        selectedIndex: index,
                                        gallery: widget.places.gallery),
                                  );
                                },
                              ),
                            ),
                            CustomCard(
                              title: 'مشحصات',
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: widget.places.adresses.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  phoneData
                                      .add(widget.places.adresses[index].phone);
                                  addressData.add(
                                      widget.places.adresses[index].address);
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
                                                    '${widget.places.adresses[index].address} ',
                                                    maxLines: 4,
                                                    overflow: TextOverflow.fade,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black54)),
                                              ),
                                            ],
                                          )),
                                      ConstrainedBox(
                                        constraints:
                                            const BoxConstraints(minWidth: 120),
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8)),
                                          onPressed: () async {
                                            await FlutterPhoneDirectCaller
                                                .callNumber(
                                              widget
                                                  .places.adresses[index].phone,
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                  widget.places.adresses[index]
                                                      .phone,
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
            ),
    );
  }
}
