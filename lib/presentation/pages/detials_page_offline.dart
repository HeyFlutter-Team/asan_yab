import 'dart:convert';
import 'dart:typed_data';

import 'package:asan_yab/data/models/language.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/convert_digits_to_farsi.dart';
import '../../data/repositoris/language_repository.dart';
import '../../domain/riverpod/data/favorite_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/phone_widget.dart';

class DetailPageOffline extends ConsumerWidget {
  final Map<String, dynamic> favItem;
  const DetailPageOffline({super.key, required this.favItem});

  @override
  Widget build(BuildContext context, ref) {
    final isRTL = ref.watch(languageProvider).code == 'fa';
    final languageText = AppLocalizations.of(context);
    List<String> phoneData = List<String>.from(jsonDecode(favItem['phone']));
    List<String> addressData =
        List<String>.from(jsonDecode(favItem['address']));
    final provider = ref.read(favoriteProvider.notifier);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 25,
                ),
                IconButton(
                  onPressed: () {
                    provider.delete(favItem['id']);
                    Navigator.pop(context);
                  },
                  icon: ref
                          .watch(favoriteProvider.notifier)
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
                      const SizedBox(height: 10),
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
                                  Uint8List.fromList(favItem['coverImage']))),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                      CustomCard(
                        title: '${languageText?.details_page_1_custom_card}',
                        child: Text(favItem['dec']),
                      ),
                      CustomCard(
                        title: '${languageText?.details_page_3_custom_card}',
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: phoneData.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.location_on_outlined),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        Flexible(
                                          child: Text(addressData[index],
                                              maxLines: 4,
                                              overflow: TextOverflow.fade,
                                              style:  TextStyle(
                                                  fontSize: 14,
                                                color: Colors.grey.withOpacity(0.5),
                                              )),
                                        ),
                                      ],
                                    )),
                                Directionality(

                                    textDirection:isRTL? TextDirection.rtl:TextDirection.ltr,
                                    child: buildPhoneNumberWidget(context: context, isRTL: isRTL, phone:phoneData[index] )
                                ),                              ],
                            );
                          },
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

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.title,
    this.description,
    required this.child,
  });

  final String title;
  final String? description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.library_books,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 4),
                    Directionality(

                      textDirection: TextDirection.rtl,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: child,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
