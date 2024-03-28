import 'package:asan_yab/core/utils/convert_digits_to_farsi.dart';
import 'package:asan_yab/core/extensions/language.dart';
import 'package:asan_yab/domain/riverpod/data/lazy_loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/res/image_res.dart';
import '../../data/repositoris/language_repo.dart';
import '../../domain/riverpod/data/categories_items_provider.dart';
import '../../domain/riverpod/screen/loading_circularPRI_provider.dart';
import '../pages/detials_page.dart';

final idProvider = StateProvider((ref) => '');

class CategoryItemWidget extends ConsumerStatefulWidget {
  final String id;
  const CategoryItemWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryItemState();
}

class _CategoryItemState extends ConsumerState<CategoryItemWidget> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      debugPrint('id for cat ${widget.id}');
      ref.read(idProvider.notifier).state = widget.id;
      Future.delayed(
        const Duration(milliseconds: 100),
        () {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            ref.read(lazyLoading.notifier).loadMoreData();
          });
        },
      );
      await ref.read(categoriesItemsProvider.notifier).getInitPlaces(widget.id);
      ref.read(loadingProvider.notifier).state = !ref.watch(loadingProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.width;
    final data = ref.watch(categoriesItemsProvider);
    final isRTL = ref.watch(languageProvider).code == 'fa';
    debugPrint('Ui is load : $data ');
    debugPrint('Ui is load : ${ref.watch(hasMore)} ');

    return ref.watch(loadingDataProvider) || ref.watch(loadingProvider)
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.blueGrey,
              strokeWidth: 5,
            ),
          )
        : ListView.builder(
            controller: ref.read(lazyLoading.notifier).scrollController,
            itemCount: ref.watch(hasMore) ? (data.length + 1) : data.length,
            itemBuilder: (context, index) {
              if (index < data.length) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(id: data[index].id),
                      ),
                    );
                    FirebaseAnalytics.instance.logEvent(
                      name: 'humm_1',
                      parameters: <String, dynamic>{
                        'clicked_on': data[index].name,
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          height: screenHeight * 0.25,
                          width: screenWidth * 0.25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) =>
                                      Image.asset(ImageRes.asanYab),
                                  imageUrl: data[index].logo,
                                  width: double.maxFinite,
                                  height: double.maxFinite,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 12.0, left: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data[index].name,
                                  overflow: TextOverflow.fade,
                                  maxLines: 2,
                                  style: const TextStyle(fontSize: 18.0),
                                ),
                                const SizedBox(height: 12.0),
                                data[index].addresses[0].phone.isEmpty
                                    ? const SizedBox()
                                    : SizedBox(
                                        width: 180,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.black.withOpacity(0.3),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                          onPressed: () async =>
                                              await FlutterPhoneDirectCaller
                                                  .callNumber(data[index]
                                                      .addresses[0]
                                                      .phone),
                                          child: isRTL
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      isRTL
                                                          ? convertDigitsToFarsi(
                                                              data[index]
                                                                  .addresses
                                                                  .first
                                                                  .phone)
                                                          : data[index]
                                                              .addresses
                                                              .first
                                                              .phone,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.0),
                                                    ),
                                                    const Icon(
                                                      Icons.phone_android,
                                                      color: Colors.green,
                                                      size: 25,
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    const Icon(
                                                      Icons.phone_android,
                                                      color: Colors.green,
                                                      size: 25,
                                                    ),
                                                    Text(
                                                      isRTL
                                                          ? convertDigitsToFarsi(
                                                              data[index]
                                                                  .addresses
                                                                  .first
                                                                  .phone)
                                                          : data[index]
                                                              .addresses
                                                              .first
                                                              .phone,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.0),
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
                  ),
                );
              } else if (index == data.length) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          );
  }
}
