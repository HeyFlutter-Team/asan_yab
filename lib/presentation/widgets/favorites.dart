// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';
import 'package:asan_yab/data/models/language.dart';
import 'package:asan_yab/domain/riverpod/data/firebase_rating_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/convert_digits_to_farsi.dart';
import '../../data/repositoris/language_repository.dart';
import '../../domain/riverpod/data/favorite_provider.dart';
import '../../domain/riverpod/data/firbase_favorite_provider.dart';
import '../pages/detials_page.dart';
import '../pages/detials_page_offline.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Favorites extends ConsumerStatefulWidget {
  final bool isConnected;
  const Favorites({super.key, required this.isConnected});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FavoritesState();
}

class _FavoritesState extends ConsumerState<Favorites> {
  @override
  void initState() {
    super.initState();
    ref.read(favoriteProvider.notifier).fetchUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final favoriteState = ref.watch(favoriteProvider);
    debugPrint('favorite $favoriteState');
    final favorites = favoriteState.map((e) => e).toList();
    final languageText = AppLocalizations.of(context);
    final isRTL = ref.watch(languageProvider).code == 'fa';
    print("this is the lenght");
    print(favorites.length);
    return favorites.isEmpty
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(right: 16.0, top: 12.0, left: 16),
                child: Text(
                  languageText!.favorite_page_title,
                  style: const TextStyle(color: Colors.grey, fontSize: 20.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12.0,
                    crossAxisSpacing: 12.0,
                    mainAxisExtent: 230.0,
                  ),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    print(favorites[index]);
                    final toggle =
                        favorites[index]['toggle'] == 1 ? true : false;
                    final items = favorites[index];
                    List<String> phoneData =
                        List<String>.from(jsonDecode(items['phone']));
                    final phoneNumber = isRTL
                        ? convertDigitsToFarsi(phoneData[0])
                        : phoneData[0];
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
                                            id: favorites[index]['id']),
                                      ))
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailPageOffline(
                                            favItem: favorites[index]),
                                      ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                // color: Colors.white,
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
                                        image: MemoryImage(Uint8List.fromList(
                                            favorites[index]['image'])),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12.0),
                                          topRight: Radius.circular(12.0),
                                        ),
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Column(
                                      children: [
                                        Text(
                                          favorites[index]['name'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              // color: Colors.black,
                                              ),
                                        ),
                                        OutlinedButton(
                                          onPressed: () async {
                                            await FlutterPhoneDirectCaller
                                                .callNumber(phoneNumber);
                                          },
                                          child: isRTL
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                        Icons.phone_android,
                                                        color: Colors.green),
                                                    Text(phoneNumber),
                                                  ],
                                                )
                                              : Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(phoneNumber,
                                                        overflow: TextOverflow
                                                            .ellipsis),
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
                              if (widget.isConnected) {
                                ref
                                    .read(getInformationProvider)
                                    .toggle(favorites[index]['id']);

                                ref.read(getInformationProvider).setFavorite();
                                ref
                                    .read(favoriteProvider.notifier)
                                    .delete(favorites[index]['id']);
                                print(favorites[index]['id']);
                              }
                            },
                            icon: toggle
                                ? const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 30.0,
                                  )
                                : const Icon(
                                    Icons.favorite_border,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                          ),
                        ),
                        widget.isConnected
                            ? Positioned(
                                top: 95.0,
                                left: 10.0,
                                child: FutureBuilder<double>(
                                  future: ref
                                      .read(firebaseRatingProvider)
                                      .getAverageRatingForPlace(
                                          favorites[index]['id']),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator(); // Show loading indicator while fetching rating
                                    } else if (snapshot.hasError) {
                                      return const Text(
                                          'Error fetching rating'); // Show error message if there's an error
                                    } else {
                                      final averageRating = snapshot.data ?? 0;
                                      return Container(
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: Text(
                                            isRTL
                                                ? convertDigitsToFarsi(
                                                    averageRating
                                                        .toStringAsFixed(1))
                                                : averageRating
                                                    .toStringAsFixed(1),
                                            // Display the average rating with one decimal place
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              )
                            : const SizedBox(
                                height: 0,
                              )
                      ],
                    );
                  },
                ),
              ),
            ],
          );
  }
}
