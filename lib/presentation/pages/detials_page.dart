import 'dart:io';

import 'package:asan_yab/core/utils/download_image.dart';
import 'package:asan_yab/domain/riverpod/data/toggle_favorite.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../core/res/image_res.dart';

import '../../core/utils/convert_digits_to_farsi.dart';
import '../../domain/riverpod/data/favorite_provider.dart';

import '../../domain/riverpod/data/single_place_provider.dart';
import '../widgets/page_view_item.dart';
import 'detials_page_offline.dart';

class DetailsPage extends ConsumerStatefulWidget {
  final String id;

  const DetailsPage({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DetailsPageState();
}

class _DetailsPageState extends ConsumerState<DetailsPage> {
  @override
  void initState() {
    super.initState();
    ref.read(getSingleProvider.notifier).fetchSinglePlace(widget.id);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //Todo: for selected
      final provider = ref.read(favoriteProvider.notifier);
      final toggle = provider.isExist(widget.id);
      ref.read(toggleProvider.notifier).toggle(toggle);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> phoneData = [];
    List<String> addressData = [];

    final size = MediaQuery.of(context).size;

    final provider = ref.read(favoriteProvider.notifier);

    final places = ref.watch(getSingleProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: places == null
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 5,
                color: Colors.blueGrey,
              ),
            )
          : Column(
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
                      IconButton(
                        onPressed: () {
                          if (!ref
                              .watch(favoriteProvider.notifier)
                              .isExist(places.id)) {
                            DownloadImage.getImage(
                                    places.logo, places.coverImage, context)
                                .whenComplete(() {
                              Navigator.pop(context);
                              provider.toggleFavorite(
                                  places.id,
                                  places,
                                  addressData,
                                  phoneData,
                                  DownloadImage.logo,
                                  DownloadImage.coverImage);
                            });
                          } else {
                            provider.toggleFavorite(
                                places.id,
                                places,
                                addressData,
                                phoneData,
                                DownloadImage.logo,
                                DownloadImage.coverImage);
                          }
                        },
                        icon: ref.watch(toggleProvider)
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(Icons.favorite_border),
                        iconSize: 25,
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
                            (places.coverImage == '')
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
                                          ImageRes.asanYab,
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
                                    fontSize: 24, fontWeight: FontWeight.bold),
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: places.gallery.length,
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
                                        phoneData
                                            .add(places.adresses[index].phone);
                                        addressData.add(
                                            '${places.adresses[index].branch}: ${places.adresses[index].address}');
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
                                                        if (Platform
                                                            .isAndroid) {
                                                          var uri = Uri.parse(
                                                              "google.navigation:q=${places.adresses[index].lat},${places.adresses[index].lang}&mode=d");
                                                          launchUrl(uri);
                                                        } else {
                                                          final urlAppleMaps =
                                                              Uri.parse(
                                                                  'https://maps.apple.com/?q=${places.adresses[index].lat},${places.adresses[index].lang}');
                                                          var uri = Uri.parse(
                                                              'comgooglemaps://?saddr=&daddr=${places.adresses[index].lat},${places.adresses[index].lang}&directionsmode=driving');
                                                          // launchUrl(uri);
                                                          if (await canLaunchUrl(
                                                              uri)) {
                                                            await launchUrl(
                                                                uri);
                                                          } else if (await canLaunchUrl(
                                                              urlAppleMaps)) {
                                                            await launchUrl(
                                                                urlAppleMaps);
                                                          } else {
                                                            throw 'Could not launch $uri';
                                                          }
                                                        }
                                                      },
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Icon(Icons
                                                              .location_on_outlined),
                                                          const SizedBox(
                                                              width: 3),
                                                          Flexible(
                                                            flex: 2,
                                                            child: Text(
                                                              '${places.adresses[index].branch.isNotEmpty ? ' ${places.adresses[index].branch}: ' : ''} ${places.adresses[index].address}',
                                                              maxLines: 4,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: const TextStyle(
                                                                  fontSize: 14,
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
                                                          places.adresses[index]
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
