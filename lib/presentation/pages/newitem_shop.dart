import 'package:asan_yab/core/res/image_res.dart';
import 'package:asan_yab/core/routes/routes.dart';
import 'package:asan_yab/core/utils/convert_digits_to_farsi.dart';
import 'package:asan_yab/core/extensions/language.dart';
import 'package:asan_yab/domain/riverpod/data/single_place.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../data/repositoris/language_repo.dart';

class ItemsSopping extends ConsumerStatefulWidget {
  const ItemsSopping({super.key});

  @override
  ConsumerState<ItemsSopping> createState() => _ItemsSoppingState();
}

class _ItemsSoppingState extends ConsumerState<ItemsSopping> {
  @override
  Widget build(BuildContext context) {
    final isRTL = ref.watch(languageProvider).code == 'fa';
    final places = ref.watch(singlePlaceProvider);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.9,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.vertical,
        itemCount: places!.itemImages!.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(top: 6, left: 2, right: 2, bottom: 18),
          child: GestureDetector(
            onTap: () {
              context.pushNamed(
                Routes.imageView,
                pathParameters: {
                  'index': index.toString(),
                  'imageList': places.itemImages!
                      .map((item) => item.imageUrl)
                      .toList()
                      .toString(),
                },
              );
            },
            child: Container(
              width: 220,
              height: 250,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade100
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
                      bottomRight: Radius.circular(10),
                    ),
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
                  SizedBox(height: 10.h),
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
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade500),
                            ),
                            TextSpan(
                              text: 'افغانی',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.green.shade500,
                                  fontWeight: FontWeight.bold),
                            )
                          ])
                        : TextSpan(
                            children: [
                              TextSpan(
                                text: '${places.itemImages![index].price} ',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade500),
                              ),
                              TextSpan(
                                text: 'AF',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.green.shade500,
                                  fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
