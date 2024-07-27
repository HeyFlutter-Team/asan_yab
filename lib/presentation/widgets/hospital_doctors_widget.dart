import 'package:asan_yab/data/models/language.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/res/image_res.dart';
import '../../core/utils/convert_digits_to_farsi.dart';
import '../../data/models/place.dart';
import '../../data/repositoris/language_repository.dart';
import '../pages/doctors_page.dart';

class HospitalDoctorsWidget extends ConsumerStatefulWidget {
  final Place places;
  const HospitalDoctorsWidget({super.key, required this.places});

  @override
  ConsumerState<HospitalDoctorsWidget> createState() =>
      _HospitalDoctorsWidgetState();
}

class _HospitalDoctorsWidgetState extends ConsumerState<HospitalDoctorsWidget> {
  @override
  Widget build(BuildContext context) {
    final isRTL = ref.watch(languageProvider).code == 'fa';
    final languageText = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child:
              (widget.places.doctors.isEmpty)
                  ? const SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Text(
                            '${languageText?.details_page_7_custom_card}',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Doctors_Page(),
                              ),
                            );
                          },
                          icon: Icon(
                            isRTL
                                ? Icons.arrow_circle_left_outlined
                                : Icons.arrow_circle_right_outlined,
                            size: 30,
                          ),
                          // color: Colors.black54,
                        ),
                        const SizedBox(height: 12)
                      ],
                    ),
        ),
        const SizedBox(
          height: 5,
        ),
        widget.places.doctors == null || widget.places.doctors.isEmpty
            ? const SizedBox(height: 0)
            : SizedBox(
                height: size.height * 0.28,
                child: ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 20,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.places.doctors!.length >= 5
                      ? 5
                      : widget.places.doctors!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 6, left: 2, right: 2, bottom: 18),
                      child: Container(
                        width: size.width * 0.25,
                        height: 160,
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness ==
                                  Brightness.light
                              ? Colors.grey.shade100 // Set light theme color
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
                                  bottomRight: Radius.circular(10)),
                              child: CachedNetworkImage(
                                imageUrl:
                                    widget.places.doctors[index].image.url!,
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
                            const SizedBox(height: 8),
                            Text(
                              widget.places.doctors![index].name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              widget.places.doctors[index].specialist,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.green.shade400,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              '${languageText?.details_page_9_custom_card}: ${isRTL ? convertDigitsToFarsi(widget.places.doctors[index].time.startTime) : widget.places.doctors[index].time.startTime}',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.green.shade500,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
