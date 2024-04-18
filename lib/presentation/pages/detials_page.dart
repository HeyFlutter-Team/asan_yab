import 'dart:io';
import 'package:asan_yab/core/utils/download_image.dart';
import 'package:asan_yab/data/models/language.dart';
import 'package:asan_yab/data/models/place.dart';
import 'package:asan_yab/domain/riverpod/data/toggle_favorite.dart';
import 'package:asan_yab/presentation/pages/doctors_page.dart';
import 'package:asan_yab/presentation/pages/google_map_page.dart';
import 'package:asan_yab/presentation/pages/menu_restaurant_page.dart';
import 'package:asan_yab/presentation/pages/newitem_shop.dart';
import 'package:asan_yab/presentation/widgets/comments.dart';
import 'package:asan_yab/presentation/widgets/rating.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
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
                          ref.read(getSingleProvider.notifier).state = null;
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
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RatingWidgets(
                                  postId: places.id,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20),
                                  child: (places.menuItemName == null ||
                                          places.menuItemName!.isEmpty)
                                      ? SizedBox()
                                      : ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MenuRestaurant(
                                                          placeId: places.id),
                                                ));
                                          },
                                          style: ElevatedButton.styleFrom(
                                            elevation: 5,
                                            minimumSize: Size(70, 35),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                '${languageText?.menus_restaurant}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light
                                                      ? Colors
                                                          .black // Set light theme color
                                                      : Colors.white,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 7,
                                              ),
                                              Icon(Icons.menu_open,
                                                  size: 20,
                                                  color: Colors.blue.shade800),
                                            ],
                                          ),
                                        ),
                                ),
                              ],
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${languageText?.details_page_4_custom_card}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const ItemsSopping(),
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            isRTL
                                                ? Icons
                                                    .arrow_circle_left_outlined
                                                : Icons
                                                    .arrow_circle_right_outlined,
                                            size: 30,
                                          ),
                                          // color: Colors.black54,
                                        ),
                                        const SizedBox(width: 8),
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
                                    height: size.height * 0.25,
                                    child: ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                        width: 20,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: places.itemImages!.length >= 5
                                          ? 5
                                          : places.itemImages!.length,
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
                                              width: size.width * 0.25,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.light
                                                    ? Colors.grey
                                                        .shade100 // Set light theme color
                                                    : Colors.black12,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    30),
                                                            topLeft:
                                                                Radius.circular(
                                                                    30),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10)),
                                                    child: CachedNetworkImage(
                                                      imageUrl: places
                                                          .itemImages![index]
                                                          .imageUrl,
                                                      width: size.width * 0.24,
                                                      height:
                                                          size.height * 0.13,
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
                                                    maxLines: 1,
                                                    places.itemImages![index]
                                                        .name,
                                                    style: const TextStyle(
                                                      overflow:
                                                          TextOverflow.fade,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  RichText(
                                                    overflow: TextOverflow.clip,
                                                    maxLines: 1,
                                                    text: isRTL
                                                        ? TextSpan(children: [
                                                            TextSpan(
                                                              text:
                                                                  '${convertDigitsToFarsi(places.itemImages![index].price)} ',
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .green
                                                                      .shade500),
                                                            ),
                                                            TextSpan(
                                                              text: 'افغانی',
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .green
                                                                      .shade500,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                          ])
                                                        : TextSpan(children: [
                                                            TextSpan(
                                                              text:
                                                                  '${places.itemImages![index].price} ',
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .green
                                                                      .shade500),
                                                            ),
                                                            TextSpan(
                                                              text: 'AF',
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .green
                                                                      .shade500,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ]),
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
                            SizedBox(
                              height: 8,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: (places.doctors == null ||
                                      places.doctors!.isEmpty)
                                  ? const SizedBox()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${languageText?.details_page_7_custom_card}',
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const Doctors_Page(),
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            isRTL
                                                ? Icons
                                                    .arrow_circle_left_outlined
                                                : Icons
                                                    .arrow_circle_right_outlined,
                                            size: 30,
                                          ),
                                          // color: Colors.black54,
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
                                    height: size.height * 0.28,
                                    child: ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                        width: 20,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: places.doctors!.length >= 5
                                          ? 5
                                          : places.doctors!.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              top: 6,
                                              left: 2,
                                              right: 2,
                                              bottom: 18),
                                          child: Container(
                                            width: size.width * 0.25,
                                            height: 160,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Colors.grey
                                                      .shade100 // Set light theme color
                                                  : Colors.black12,
                                              borderRadius:
                                                  BorderRadius.circular(22),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  22),
                                                          topLeft:
                                                              Radius.circular(
                                                                  22),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10)),
                                                  child: CachedNetworkImage(
                                                    imageUrl: places
                                                        .doctors![index]
                                                        .imageUrl,
                                                    width: size.width * 0.24,
                                                    height: size.height * 0.13,
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
                                                  places.doctors![index].name,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  maxLines: 1,
                                                  overflow: TextOverflow.fade,
                                                  places.doctors![index].title,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color:
                                                          Colors.green.shade400,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  maxLines: 1,
                                                  overflow: TextOverflow.fade,
                                                  '${languageText?.details_page_9_custom_card}: ${isRTL ? convertDigitsToFarsi(places.doctors![index].time) : places.doctors![index].time}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color:
                                                          Colors.green.shade500,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                            ////hojjat finish////

                            places.addresses.last.lang.isNotEmpty &&
                                    places.addresses.last.lat.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: InkWell(
                                      onTap: () {
                                        print('hojjat6');
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: Colors.black12),
                                        height: 200,
                                        width: 400,
                                        child: const GoogleMapPage(),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
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
