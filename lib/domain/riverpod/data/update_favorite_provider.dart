import 'package:asan_yab/data/models/place.dart';
import 'package:asan_yab/domain/riverpod/data/favorite_item.dart';
import 'package:asan_yab/domain/riverpod/data/single_place.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/download_image.dart';
import 'firbase_favorite_provider.dart';

final updateFavoriteProvider = ChangeNotifierProvider<UpdateFavoriteProvider>(
    (ref) => UpdateFavoriteProvider());

class UpdateFavoriteProvider extends ChangeNotifier {
  UpdateFavoriteProvider();
  Future<void> update(
    BuildContext context,
    WidgetRef ref,
  ) async {
    await ref.read(getFavoriteProvider.notifier).getFavorite();
    final firebaseId = ref.watch(getFavoriteProvider).favoriteList;
    await ref.read(favoriteItemProvider.notifier).fetchUser();
    final phoneId =
        ref.watch(favoriteItemProvider).map((e) => e['id'].toString()).toList();
    debugPrint(firebaseId.toString());
    List<String> phoneData = [];
    List<String> addressData = [];

    for (int i = 0; i < firebaseId.length; i++) {
      if (!(phoneId.contains(firebaseId[i]))) {
        await ref
            .read(singlePlaceProvider.notifier)
            .fetchSinglePlace(firebaseId[i])
            .whenComplete(
          () async {
            final places = ref.watch(singlePlaceProvider);
            addressData = [];
            phoneData = [];
            if (places != null) {
              for (int i = 0; i < places.addresses.length; i++) {
                addressData.add(
                    '${places.addresses[i].branch}: ${places.addresses[i].address}');
                phoneData.add(places.addresses[i].phone);
              }
              await DownloadImage.getImage(
                places.logo,
                places.coverImage,
                context,
              ).then(
                (_) {
                  context.pop();
                  ref.read(favoriteItemProvider.notifier).toggleFavorite(
                        places.id,
                        places,
                        addressData,
                        phoneData,
                        DownloadImage.logo,
                        DownloadImage.coverImage,
                      );
                },
              );
            }
          },
        );
      }
    }

    for (int i = 0; i < phoneId.length; i++) {
      if (!(firebaseId.contains(phoneId[i]))) {
        final provider = ref.read(favoriteItemProvider.notifier);
        final places = Place(
          categoryId: '',
          category: '',
          addresses: [],
          id: phoneId[i],
          logo: '',
          coverImage: '',
          name: '',
          description: '',
          gallery: [],
          createdAt: DateTime.now(),
          order: 1,
        );
        addressData = [];
        phoneData = [];

        for (int i = 0; i < places.addresses.length; i++) {
          addressData.add(
              '${places.addresses[i].branch}: ${places.addresses[i].address}');
          phoneData.add(places.addresses[i].phone);
        }
        provider.toggleFavorite(
          phoneId[i],
          places,
          addressData,
          phoneData,
          DownloadImage.logo,
          DownloadImage.coverImage,
        );
      }
    }
    notifyListeners();
  }
}
