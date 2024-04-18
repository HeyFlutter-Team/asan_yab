import 'dart:convert';
import 'dart:typed_data';

import 'package:asan_yab/core/extensions/language.dart';
import 'package:asan_yab/domain/riverpod/data/favorite_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/convert_digits_to_farsi.dart';
import '../../data/repositoris/language_repo.dart';
import '../widgets/custom_cards_widget.dart';

class OfflineDetailPage extends ConsumerWidget {
  final Map<String, dynamic> favItem;
  const OfflineDetailPage({super.key, required this.favItem});

  @override
  Widget build(BuildContext context, ref) {
    final isRTL = ref.watch(languageProvider).code == 'fa';
    final phoneData = List<String>.from(jsonDecode(favItem['phone']));
    final addressData = List<String>.from(jsonDecode(favItem['address']));
    final provider = ref.read(favoriteItemProvider.notifier);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 25,
                ),
                IconButton(
                  onPressed: () {
                    provider.delete(favItem['id']);
                    context.pop();
                  },
                  icon: ref
                          .watch(favoriteItemProvider.notifier)
                          .isExist(favItem['id'])
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(Icons.favorite_border),
                  iconSize: 25,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 10.h),
                      Container(
                        width: size.width * 0.93,
                        height: size.height * 0.31,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.22,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: MemoryImage(
                              Uint8List.fromList(favItem['coverImage']),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          favItem['name'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 12),
                      CustomCardsWidget(
                        title: 'توضیحات',
                        child: Text(favItem['dec']),
                      ),
                      CustomCardsWidget(
                        title: 'مشخصات',
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: phoneData.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.location_on_outlined),
                                    SizedBox(width: 3.w),
                                    Flexible(
                                      child: Text(addressData[index],
                                          maxLines: 4,
                                          overflow: TextOverflow.fade,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54)),
                                    ),
                                  ],
                                ),
                              ),
                              ConstrainedBox(
                                constraints:
                                    const BoxConstraints(minWidth: 120),
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8)),
                                  onPressed: () async =>
                                      await FlutterPhoneDirectCaller.callNumber(
                                    phoneData[index],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        isRTL
                                            ? convertDigitsToFarsi(
                                                phoneData[index])
                                            : phoneData[index],
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54),
                                      ),
                                      SizedBox(width: 8.w),
                                      const Icon(
                                        Icons.phone_android_sharp,
                                        color: Colors.green,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
