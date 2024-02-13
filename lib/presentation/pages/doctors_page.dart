import 'package:asan_yab/core/res/image_res.dart';
import 'package:asan_yab/core/utils/convert_digits_to_farsi.dart';
import 'package:asan_yab/data/models/language.dart';
import 'package:asan_yab/data/repositoris/language_repository.dart';
import 'package:asan_yab/domain/riverpod/data/single_place_provider.dart';
import 'package:asan_yab/presentation/widgets/page_view_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Doctors_Page extends ConsumerStatefulWidget {
  const Doctors_Page({super.key});

  @override
  ConsumerState<Doctors_Page> createState() => _Doctors_PageState();
}

class _Doctors_PageState extends ConsumerState<Doctors_Page> {
  @override
  Widget build(BuildContext context) {
    final isRTL = ref.watch(languageProvider).code == 'fa';
    final places = ref.watch(getSingleProvider);
    final size = MediaQuery.of(context).size;
    final languageText = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(),
      body:GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.7,
          crossAxisCount: 2, // Number of columns
          crossAxisSpacing: 8.0, // Spacing between columns
          mainAxisSpacing: 8.0, // Spacing between rows
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.vertical,
        itemCount: places!.doctors?.length,
        itemBuilder: (context, index) {
          return Padding(
            padding:
            const EdgeInsets.only(top: 6, left: 2, right: 2, bottom: 18),
            child: Container(
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
                      imageUrl: places
                          .doctors![index]
                          .imageUrl,
                      width: double.infinity,
                      height: size.height * 0.16,
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
                  const SizedBox(height: 20),
                  Text(
                    places.doctors![index].name,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    maxLines: 1,
                    overflow:TextOverflow.fade,
                    places.doctors![index].title,
                    style:  TextStyle(
                        fontSize: 16,
                        color: Colors.green.shade400,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    maxLines: 1,
                    overflow:TextOverflow.fade,
                    '${languageText?.details_page_9_custom_card}: ${isRTL ? convertDigitsToFarsi(places.doctors![index].time) : places.doctors![index].time}',
                    style:  TextStyle(
                        fontSize: 16,
                        color: Colors.green.shade400,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}