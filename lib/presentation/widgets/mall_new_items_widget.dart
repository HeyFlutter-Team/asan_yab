import 'package:asan_yab/data/models/language.dart';
import 'package:asan_yab/data/models/place.dart';
import 'package:asan_yab/presentation/widgets/page_view_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/res/image_res.dart';
import '../../core/utils/convert_digits_to_farsi.dart';
import '../../data/repositoris/language_repository.dart';
import '../pages/newitem_shop.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MallNewItemsWidget extends ConsumerStatefulWidget {
  final Place places;
  const MallNewItemsWidget({super.key,required this.places});

  @override
  ConsumerState<MallNewItemsWidget> createState() => _MallNewItemsWidgetState();
}

class _MallNewItemsWidgetState extends ConsumerState<MallNewItemsWidget> {
  @override
  Widget build(BuildContext context) {
    final isRTL = ref.watch(languageProvider).code == 'fa';
    final languageText = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 12),
          child: (widget.places.itemImages == null ||
              widget.places.itemImages!.isEmpty)
              ? const SizedBox()
              : Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${languageText?.details_page_4_custom_card}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const ItemsSopping(),
                    ),
                  );
                },
                icon: Icon(
                  isRTL
                      ? Icons
                      .arrow_circle_left_outlined
                      : Icons
                      .arrow_circle_right_outlined,
                  size: 30,
                ),
                // color: Colors.black54,
              ),
              const SizedBox(width: 8),
              const SizedBox(height: 12)
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        widget.places.itemImages == null ||
            widget.places.itemImages!.isEmpty
            ? const SizedBox(height: 0)
            : SizedBox(
          height: size.height * 0.25,
          child: ListView.separated(
            separatorBuilder: (context, index) =>
            const SizedBox(
              width: 20,
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: widget.places.itemImages!.length >= 5
                ? 5
                : widget.places.itemImages!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                    top: 6,
                    left: 2,
                    right: 2,
                    bottom: 18),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ImageView(
                              selectedIndex: index,
                              gallery: widget.places.itemImages!
                                  .map((item) =>
                              item.imageUrl)
                                  .toList(),
                            ),
                      ),
                    );
                  },
                  child: Container(
                    width: size.width * 0.25,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .brightness ==
                          Brightness.light
                          ? Colors.grey
                          .shade100 // Set light theme color
                          : Colors.black12,
                      borderRadius:
                      BorderRadius.circular(30),
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius:
                          const BorderRadius.only(
                              topRight:
                              Radius.circular(
                                  30),
                              topLeft:
                              Radius.circular(
                                  30),
                              bottomLeft:
                              Radius.circular(
                                  10),
                              bottomRight:
                              Radius.circular(
                                  10)),
                          child: CachedNetworkImage(
                            imageUrl: widget.places
                                .itemImages![index]
                                .imageUrl,
                            width: size.width * 0.24,
                            height:
                            size.height * 0.13,
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
                        const SizedBox(height: 8),
                        Text(
                          maxLines: 1,
                          widget.places.itemImages![index]
                              .name,
                          style: const TextStyle(
                            overflow:
                            TextOverflow.fade,
                            fontSize: 16,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          text: isRTL
                              ? TextSpan(children: [
                            TextSpan(
                              text:
                              '${convertDigitsToFarsi(widget.places.itemImages![index].price)} ',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                  color: Colors
                                      .green
                                      .shade500),
                            ),
                            TextSpan(
                              text: 'افغانی',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors
                                      .green
                                      .shade500,
                                  fontWeight:
                                  FontWeight
                                      .bold),
                            )
                          ])
                              : TextSpan(children: [
                            TextSpan(
                              text:
                              '${widget.places.itemImages![index].price} ',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                  color: Colors
                                      .green
                                      .shade500),
                            ),
                            TextSpan(
                              text: 'AF',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors
                                      .green
                                      .shade500,
                                  fontWeight:
                                  FontWeight
                                      .bold),
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
        ),
      ],
    );
  }
}
