import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/download_image.dart';
import '../../data/models/place.dart';
import '../../domain/riverpod/data/favorite_item.dart';
import '../../domain/riverpod/data/firbase_favorite_provider.dart';
import '../../domain/riverpod/data/single_place.dart';
import '../../domain/riverpod/data/toggle_favorite.dart';
import '../pages/detials_page.dart';

class HeaderDetailsWidget extends StatelessWidget {
  const HeaderDetailsWidget({
    super.key,
    required this.ref,
    required this.widget,
    required this.places,
    required this.provider,
    required this.addressData,
    required this.phoneData,
    required this.text,
  });

  final WidgetRef ref;
  final DetailsPage widget;
  final Place? places;
  final FavoriteItem provider;
  final List<String> addressData;
  final List<String> phoneData;
  final AppLocalizations text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              ref.read(singlePlaceProvider.notifier).state = null;
              context.pop();
            },
            icon: const Icon(Icons.arrow_back),
            iconSize: 25,
          ),
          IconButton(
            onPressed: () {
              bool isLogin = FirebaseAuth.instance.currentUser != null;
              if (isLogin) {
                ref.watch(getFavoriteProvider).toggle(widget.id);
                ref.watch(getFavoriteProvider).setFavorite();

                if (!ref
                    .watch(favoriteItemProvider.notifier)
                    .isExist(places!.id)) {
                  DownloadImage.getImage(
                          places!.logo, places!.coverImage, context)
                      .whenComplete(() {
                    context.pop();
                    provider.toggleFavorite(
                        places!.id,
                        places!,
                        addressData,
                        phoneData,
                        DownloadImage.logo,
                        DownloadImage.coverImage);
                  });
                } else {
                  provider.toggleFavorite(places!.id, places!, addressData,
                      phoneData, DownloadImage.logo, DownloadImage.coverImage);
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(text.details_page_snack_bar),
                  ),
                );
              }
            },
            icon: ref.watch(toggleFavoriteProvider)
                ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
                : const Icon(Icons.favorite_border),
            iconSize: 25,
          ),
        ],
      ),
    );
  }
}
