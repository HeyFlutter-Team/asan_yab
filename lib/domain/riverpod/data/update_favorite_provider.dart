import 'package:asan_yab/domain/riverpod/data/single_place_provider.dart';
import 'package:asan_yab/domain/riverpod/data/toggle_favorite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/download_image.dart';
import 'favorite_provider.dart';
import 'firbase_favorite_provider.dart';

final updateProvider =
    ChangeNotifierProvider<UpdateFavorite>((ref) => UpdateFavorite());

class UpdateFavorite extends ChangeNotifier {
  Future<void> update(BuildContext context, WidgetRef ref) async {
    await ref.read(getInformationProvider).getFavorite();
    List<String> firebaseId =
        await ref.watch(getInformationProvider).favoriteList;
    final provider = ref.watch(favoriteProvider);
    final phoneId = provider.map((e) => e['id']).toList();

    List<String> phoneData = [];
    List<String> addressData = [];

    //if  the ides of firebase  are not into the  ides list of phone ,it gets all the information into phone
    // firebase ides ---> phone ides

    for (int i = 0; i < firebaseId.length; i++) {
      if (!phoneId.contains(firebaseId[i])) {
        ref
            .read(getSingleProvider.notifier)
            .fetchSinglePlace(firebaseId[i])
            .whenComplete(() {
          final toggle =
              ref.read(favoriteProvider.notifier).isExist(firebaseId[i]);
          ref.read(toggleProvider.notifier).toggle(toggle);
          final provider = ref.read(favoriteProvider.notifier);
          final places = ref.watch(getSingleProvider);
          addressData = [];
          phoneData = [];

          // this loop just add same same addresses and phone numbers that needed into  2 lists , which are above
          //  lists name {phoneData    ,  addressData}

          if (places != null) {
            for (int i = 0; i < places.adresses.length; i++) {
              addressData.add(
                  '${places.adresses[i].branch}: ${places.adresses[i].address}');
              phoneData.add(places.adresses[i].phone);
            }
            DownloadImage.getImage(places.logo, places.coverImage, context)
                .whenComplete(() {
              Navigator.pop(context);
              provider.toggleFavorite(places.id, places, addressData, phoneData,
                  DownloadImage.logo, DownloadImage.coverImage);
            });
          }
        });
      }
    }

    // this loop check the phones ides that are they into firebase ides or not
    //if  the ides are not into  firebase this  , it delete that extra  id from phones ides
    // phones id ---> firebase id

    for (int i = 0; i < phoneId.length; i++) {
      if (!firebaseId.contains(phoneId[i])) {
        ref
            .read(getSingleProvider.notifier)
            .fetchSinglePlace(phoneId[i])
            .whenComplete(() {
          final toggle =
              ref.read(favoriteProvider.notifier).isExist(phoneId[i]);
          ref.read(toggleProvider.notifier).toggle(toggle);
          final provider = ref.read(favoriteProvider.notifier);
          final places = ref.read(getSingleProvider);
          addressData = [];
          phoneData = [];
          if (places != null) {
            for (int i = 0; i < places.adresses.length; i++) {
              addressData.add(
                  '${places.adresses[i].branch}: ${places.adresses[i].address}');
              phoneData.add(places.adresses[i].phone);
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
        });
      }
    }
    notifyListeners();
  }
}
