import 'package:asan_yab/core/res/image_res.dart';
import 'package:asan_yab/core/utils/convert_digits_to_farsi.dart';
import 'package:asan_yab/core/extensions/language.dart';
import 'package:asan_yab/core/utils/translation_util.dart';
import 'package:asan_yab/data/repositoris/language_repo.dart';
import 'package:asan_yab/domain/riverpod/data/single_place.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorsPage extends ConsumerStatefulWidget {
  const DoctorsPage({super.key});

  @override
  ConsumerState<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends ConsumerState<DoctorsPage> {
  @override
  Widget build(BuildContext context) {
    final isRTL = ref.watch(languageProvider).code == 'fa';
    final places = ref.watch(singlePlaceProvider);
    final size = MediaQuery.of(context).size;
    final text = texts(context);
    return Scaffold(
      appBar: AppBar(),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.7,
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
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
                      imageUrl: places.doctors![index].imageUrl,
                      width: double.infinity,
                      height: size.height * 0.16,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset(
                        ImageRes.asanYab,
                        height: 170,
                        width: 130,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    places.doctors![index].name,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    places.doctors![index].spendTime,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.green.shade400,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    '${text.details_page_9_custom_card}: ${isRTL ? convertDigitsToFarsi(places.doctors![index].spendTime) : places.doctors![index].spendTime}',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.green.shade400,
                        fontWeight: FontWeight.w500),
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
