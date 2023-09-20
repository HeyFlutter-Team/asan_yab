import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/convert_digits_to_farsi.dart';
import '../../domain/riverpod/data/favorite_provider.dart';

class DetailPageOffline extends ConsumerWidget {
  final Map<String, dynamic> favItem;
  const DetailPageOffline({super.key, required this.favItem});

  @override
  Widget build(BuildContext context, ref) {
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
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 12),
                      CustomCard(
                        title: 'توضیحات',
                        child: Text(favItem['dec']),
                      ),
                      CustomCard(
                        title: 'مشخصات',
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
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black54)),
                                        ),
                                      ],
                                    )),
                                ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(minWidth: 120),
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8)),
                                    onPressed: () async {
                                      await FlutterPhoneDirectCaller.callNumber(
                                        phoneData[index],
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          convertDigitsToFarsi(
                                              phoneData[index]),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black54),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.phone_android_sharp,
                                          color: Colors.green,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
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
                            color: Colors.black54,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            title,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: child,
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
