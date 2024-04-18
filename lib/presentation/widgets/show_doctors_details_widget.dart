import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/res/image_res.dart';
import '../../core/utils/convert_digits_to_farsi.dart';
import '../../data/models/place.dart';

class ShowDoctorsDetailsWidget extends StatelessWidget {
  const ShowDoctorsDetailsWidget({
    super.key,
    required this.size,
    required this.places,
    required this.text,
    required this.isRTL,
  });

  final Size size;
  final Place? places;
  final AppLocalizations text;
  final bool isRTL;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.28.h,
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(width: 20.w),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: places!.doctors!.length >= 5 ? 5 : places!.doctors!.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
              top: 6,
              left: 2,
              right: 2,
              bottom: 18,
            ),
            child: Container(
              width: size.width * 0.25,
              height: 160,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade100
                    : Colors.black12,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(22),
                      topLeft: Radius.circular(22),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: places!.doctors![index].imageUrl,
                      width: size.width * 0.24,
                      height: size.height * 0.13,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset(
                        ImageRes.asanYab,
                        height: 170,
                        width: 130,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    places!.doctors![index].name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    places!.doctors![index].spendTime,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.green.shade400,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    '${text.details_page_9_custom_card}: ${isRTL ? convertDigitsToFarsi(places!.doctors![index].spendTime) : places!.doctors![index].spendTime}',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.green.shade500,
                      fontWeight: FontWeight.w500,
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
