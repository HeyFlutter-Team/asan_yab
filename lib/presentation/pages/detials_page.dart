import 'dart:io';
import 'package:asan_yab/core/utils/download_image.dart';
import 'package:asan_yab/data/models/language.dart';
import 'package:asan_yab/domain/riverpod/data/toggle_favorite.dart';
import 'package:asan_yab/presentation/widgets/comments.dart';
import 'package:asan_yab/presentation/widgets/hospital_doctors_widget.dart';
import 'package:asan_yab/presentation/widgets/mall_new_items_widget.dart';
import 'package:asan_yab/presentation/widgets/rating.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/res/image_res.dart';
import '../../data/repositoris/language_repository.dart';
import '../../domain/riverpod/data/favorite_provider.dart';
import '../../domain/riverpod/data/firbase_favorite_provider.dart';
import '../../domain/riverpod/data/firebase_rating_provider.dart';
import '../../domain/riverpod/data/single_place_provider.dart';
import '../widgets/page_view_item.dart';
import '../widgets/phone_widget.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(getSingleProvider.notifier).fetchSinglePlace(widget.id);
     await ref.read(getInformationProvider).getFavorite();
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
    return PopScope(
      onPopInvoked: (didPop) {
        ref.read(getSingleProvider.notifier).state=null;
      },
      child: Scaffold(
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
                            ref.read(getSingleProvider.notifier).state=null;
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
                                      child: Text(places.description,
                                      textDirection: TextDirection.rtl,
                                      ),
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
                              MallNewItemsWidget(places: places),

                              ////younis finish////

                              ////hojjat////

                              HospitalDoctorsWidget(places: places),
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
                                                  : Directionality(

                                                textDirection:isRTL? TextDirection.rtl:TextDirection.ltr,
                                                    child: buildPhoneNumberWidget(context: context, isRTL: isRTL, phone:places.addresses[index].phone )
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
      ),
    );
  }
}
