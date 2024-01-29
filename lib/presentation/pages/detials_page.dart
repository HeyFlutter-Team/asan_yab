import 'dart:io';
import 'package:asan_yab/core/utils/download_image.dart';
import 'package:asan_yab/data/models/language.dart';
import 'package:asan_yab/domain/riverpod/data/toggle_favorite.dart';
import 'package:asan_yab/presentation/widgets/comments.dart';

import 'package:asan_yab/presentation/widgets/rating.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/res/image_res.dart';
import '../../core/utils/convert_digits_to_farsi.dart';
import '../../data/repositoris/language_repository.dart';
import '../../domain/riverpod/data/favorite_provider.dart';
import '../../domain/riverpod/data/firbase_favorite_provider.dart';
import '../../domain/riverpod/data/firebase_rating_provider.dart';
import '../../domain/riverpod/data/single_place_provider.dart';
import '../widgets/page_view_item.dart';
import 'detials_page_offline.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      //Todo: for selected
      ref.read(getInformationProvider).getFavorite();
      final provider = ref.read(favoriteProvider.notifier);
      final toggle = provider.isExist(widget.id);
      ref.read(toggleProvider.notifier).toggle(toggle);

      ref
          .read(firebaseRatingProvider.notifier)
          .getAverageRating(postId: widget.id);
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
    ref.read(firebaseRatingProvider.notifier);
    final size = MediaQuery.of(context).size;

    final provider = ref.read(favoriteProvider.notifier);
    final isRTL = ref.watch(languageProvider).code == 'fa';
    final places = ref.watch(getSingleProvider);
    final languageText = AppLocalizations.of(context);
    return Scaffold(
      //backgroundColor: Theme.of(context).primaryColor,
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
                          bool isLogin =
                              FirebaseAuth.instance.currentUser != null;
                          if (isLogin) {
                            ref.watch(getInformationProvider).toggle(widget.id);
                            ref.watch(getInformationProvider).setFavorite();

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
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    '${languageText?.details_page_snack_bar}')));
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
                                places.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                            RatingWidgets(
                              postId: places.id,
                            ),
                            Comments(
                              postId: places.id,
                            ),
                            const SizedBox(height: 12),

                            (places.description == '' ||
                                    places.description.isEmpty)
                                ? const SizedBox()
                                : CustomCard(
                                    title:
                                        '${languageText?.details_page_1_custom_card}',
                                    child: Text(places.description),
                                  ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: (places.gallery.isEmpty)
                                  ? const SizedBox()
                                  : Row(
                                      children: [
                                        const Icon(
                                          Icons.library_books,
                                          // color: Colors.black54,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${languageText?.details_page_2_custom_card}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 12)
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

                            ////younis////
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: (places.itemImages == null ||
                                      places.itemImages!.isEmpty)
                                  ? const SizedBox()
                                  : Row(
                                      children: [
                                        const Icon(
                                          Icons.add_alert_sharp,
                                          // color: Colors.black54,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${languageText?.details_page_4_custom_card}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 12)
                                      ],
                                    ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            places.itemImages == null ||
                                    places.itemImages!.isEmpty
                                ? const SizedBox(height: 0)
                                : SizedBox(
                                    height: size.height * 0.30,
                                    child: ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                        width: 20,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: places.itemImages!.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              top: 6,
                                              left: 2,
                                              right: 2,
                                              bottom: 18),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ImageView(
                                                    selectedIndex: index,
                                                    gallery: places.itemImages!
                                                        .map((item) =>
                                                            item.imageUrl)
                                                        .toList(),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: size.width * 0.55,
                                              height: 160,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    spreadRadius: 2,
                                                    blurRadius: 5,
                                                    offset: Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            22),
                                                    child: CachedNetworkImage(
                                                      imageUrl: places
                                                          .itemImages![index]
                                                          .imageUrl,
                                                      width: double.infinity,
                                                      height:
                                                          size.height * 0.20,
                                                      fit: BoxFit.cover,
                                                      placeholder:
                                                          (context, url) =>
                                                              Image.asset(
                                                        ImageRes.asanYab,
                                                        height: 170,
                                                        width: 130,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    '${languageText!.details_page_5_custom_card}: ${places.itemImages![index].name}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    '${languageText.details_page_6_custom_card}: ${isRTL ? convertDigitsToFarsi(places.itemImages![index].price) : places.itemImages![index].price}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                            ////younis finish////

                            ////hojjat////
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: (places.doctors == null ||
                                      places.doctors!.isEmpty)
                                  ? const SizedBox()
                                  : Row(
                                      children: [
                                        const Icon(
                                          Icons.timer,
                                          // color: Colors.black54,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${languageText?.details_page_7_custom_card}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 12)
                                      ],
                                    ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            places.doctors == null || places.doctors!.isEmpty
                                ? const SizedBox(height: 0)
                                : SizedBox(
                                    height: size.height * 0.35,
                                    child: ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                        width: 20,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: places.doctors!.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              top: 6,
                                              left: 2,
                                              right: 2,
                                              bottom: 18),
                                          child: Container(
                                            width: size.width * 0.55,
                                            height: 160,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: const [
                                                BoxShadow(
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(22),
                                                  child: CachedNetworkImage(
                                                    imageUrl: places
                                                        .doctors![index]
                                                        .imageUrl,
                                                    width: double.infinity,
                                                    height: size.height * 0.20,
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        (context, url) =>
                                                            Image.asset(
                                                      ImageRes.asanYab,
                                                      height: 170,
                                                      width: 130,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  '${languageText!.details_page_5_custom_card}: ${places.doctors![index].name}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${languageText.details_page_8_custom_card}: ${places.doctors![index].title}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${languageText.details_page_9_custom_card}: ${isRTL ? convertDigitsToFarsi(places.doctors![index].time) : places.doctors![index].time}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                            ////hojjat finish////

                            (places.addresses.isEmpty)
                                ? const SizedBox()
                                : CustomCard(
                                    title:
                                        '${languageText?.details_page_3_custom_card}',
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: places.addresses.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        phoneData
                                            .add(places.addresses[index].phone);
                                        addressData.add(
                                            '${places.addresses[index].branch}: ${places.addresses[index].address}');
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: (places.addresses[index]
                                                      .address.isEmpty)
                                                  ? const SizedBox(height: 0)
                                                  : InkWell(
                                                      onTap: () async {
                                                        if (Platform
                                                            .isAndroid) {
                                                          var uri = Uri.parse(
                                                              "google.navigation:q=${places.addresses[index].lat},${places.addresses[index].lang}&mode=d");
                                                          launchUrl(uri);
                                                        } else {
                                                          final urlAppleMaps =
                                                              Uri.parse(
                                                                  'https://maps.apple.com/?q=${places.addresses[index].lat},${places.addresses[index].lang}');
                                                          var uri = Uri.parse(
                                                              'comgooglemaps://?saddr=&daddr=${places.addresses[index].lat},${places.addresses[index].lang}&directionsmode=driving');
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
                                                              '${places.addresses[index].branch.isNotEmpty ? ' ${places.addresses[index].branch}: ' : ''} ${places.addresses[index].address}',
                                                              maxLines: 4,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                                // color: Colors
                                                                //     .black54
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                            ),
                                            (places.addresses[index].phone
                                                    .isEmpty)
                                                ? const SizedBox(height: 0)
                                                : ConstrainedBox(
                                                    constraints:
                                                        const BoxConstraints(
                                                            minWidth: 120),
                                                    child: OutlinedButton(
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8)),
                                                      onPressed: () async {
                                                        await FlutterPhoneDirectCaller
                                                            .callNumber(
                                                          places
                                                              .addresses[index]
                                                              .phone,
                                                        );
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            isRTL
                                                                ? convertDigitsToFarsi(
                                                                    places
                                                                        .addresses[
                                                                            index]
                                                                        .phone)
                                                                : places
                                                                    .addresses[
                                                                        index]
                                                                    .phone,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .dark
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
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
