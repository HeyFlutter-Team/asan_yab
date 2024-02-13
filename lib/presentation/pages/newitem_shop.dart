import 'package:asan_yab/core/res/image_res.dart';
import 'package:asan_yab/core/utils/convert_digits_to_farsi.dart';
import 'package:asan_yab/data/models/language.dart';
import 'package:asan_yab/domain/riverpod/data/single_place_provider.dart';
import 'package:asan_yab/presentation/widgets/page_view_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositoris/language_repository.dart';

class ItemsSopping extends ConsumerStatefulWidget {
  const ItemsSopping({super.key});

  @override
  ConsumerState<ItemsSopping> createState() => _ItemsSoppingState();
}

class _ItemsSoppingState extends ConsumerState<ItemsSopping> {
  @override
  Widget build(BuildContext context) {
    final isRTL = ref.watch(languageProvider).code == 'fa';
    final places = ref.watch(getSingleProvider);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 5.0, // Spacing between columns
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.9// Spacing between rows
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.vertical,
        itemCount: places!.itemImages!.length,
        itemBuilder: (context, index) {
          return Padding(
            padding:
            const EdgeInsets.only(top: 6, left: 2, right: 2, bottom: 18),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageView(
                      selectedIndex: index,
                      gallery: places.itemImages!
                          .map((item) => item.imageUrl)
                          .toList(),
                    ),
                  ),
                );
              },
              child: Container(
                width: 220,
                height: 250,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey.shade100 // Set light theme color
                      : Colors.black12,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(25),
                          topLeft: Radius.circular(25),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      child: CachedNetworkImage(
                        imageUrl: places.itemImages![index].imageUrl,
                        width: double.infinity,
                        height: size.height * 0.14,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Image.asset(
                          ImageRes.asanYab,
                          height: 170,
                          width: 130,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      maxLines: 1,
                      places.itemImages![index].name,
                      style: const TextStyle(
                        overflow: TextOverflow.fade,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    RichText(
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      text: isRTL
                          ? TextSpan(children: [
                        TextSpan(
                          text:
                          '${convertDigitsToFarsi(places.itemImages![index].price)} ',
                          style:  TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold,
                              color: Colors.green.shade500

                          ),
                        ),
                        TextSpan(
                          text: 'افغانی',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.green.shade500,
                              fontWeight: FontWeight.bold),
                        )
                      ])
                          : TextSpan(children: [
                        TextSpan(
                          text: '${places.itemImages![index].price} ',
                          style:  TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold,
                              color: Colors.green.shade500
                          ),
                        ),
                        TextSpan(
                          text: 'AF',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.green.shade500,
                              fontWeight: FontWeight.bold),
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
    );
  }
}