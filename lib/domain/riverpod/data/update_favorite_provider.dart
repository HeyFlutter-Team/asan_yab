import 'package:asan_yab/data/models/place.dart';
import 'package:asan_yab/domain/riverpod/data/single_place_provider.dart';
import 'package:asan_yab/domain/riverpod/data/toggle_favorite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        ref.watch(getInformationProvider.notifier).favoriteList;
    List<String> phoneId =
        ref.watch(favoriteProvider).map((e) => e['id'].toString()).toList();

    print("thooooooooooooooooooooos${firebaseId.length}");
    print("thisssssssssssssssssss   ${phoneId.length}");

    List<String> phoneData = [];
    List<String> addressData = [];

    // if  the ides of firebase  are not into the  ides list of phone ,it gets all the information into phone
    // firebase ides ---> phone ides

    for (int i = 0; i < firebaseId.length; i++) {
      if (!(phoneId.contains(firebaseId[i]))) {
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
            for (int i = 0; i < places.addresses.length; i++) {
              addressData.add(
                  '${places.addresses[i].branch}: ${places.addresses[i].address}');
              phoneData.add(places.addresses[i].phone);
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
    // if  the ides are not into  firebase this  , it delete that extra  id from phones ides
    // phones id ---> firebase id

    for (int i = 0; i < phoneId.length; i++) {
      if (!(firebaseId.contains(phoneId[i]))) {
        final toggle = ref.read(favoriteProvider.notifier).isExist(phoneId[i]);
        ref.read(toggleProvider.notifier).toggle(toggle);
        final provider = ref.read(favoriteProvider.notifier);
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
            createdAt: DateTime.now(), order:1 ,);
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
