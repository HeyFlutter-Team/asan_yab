import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/convert_digits_to_farsi.dart';
import '../../domain/riverpod/data/favorite_provider.dart';
import '../pages/detials_page.dart';
import '../pages/detials_page_offline.dart';

class Favorites extends ConsumerStatefulWidget {
  final bool isConnected;
  const Favorites({super.key, required this.isConnected});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FavoritesState();
}

class _FavoritesState extends ConsumerState<Favorites> {
  @override
  void initState() {
    super.initState();
    ref.read(favoriteProvider.notifier).fetchUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final value1 = ref.watch(favoriteProvider);
    debugPrint('favorit $value1');
    final value = value1.map((e) => e).toList();
    return value.isEmpty
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 16.0, top: 12.0),
                child: Text(
                  'موارد دلخواه',
                  style: TextStyle(color: Colors.grey, fontSize: 20.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12.0,
                    crossAxisSpacing: 12.0,
                    mainAxisExtent: 230.0,
                  ),
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    final toggle = value[index]['toggle'] == 1 ? true : false;
                    final items = value[index];
                    List<String> phoneData =
                        List<String>.from(jsonDecode(items['phone']));
                    final phoneNumber = convertDigitsToFarsi(phoneData[0]);
                    return Stack(
                      children: [
                        Card(
                          child: GestureDetector(
                            onTap: () {
                              debugPrint(
                                  'Ramin check connectivity: ${widget.isConnected}');
                              widget.isConnected
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailsPage(id: value[index]['id']),
                                      ))
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailPageOffline(
                                            favItem: value[index]),
                                      ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: screenHeight * 0.15,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                      image: DecorationImage(
                                        image: MemoryImage(Uint8List.fromList(
                                            value[index]['image'])),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12.0),
                                          topRight: Radius.circular(12.0),
                                        ),
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Column(
                                      children: [
                                        Text(
                                          value[index]['name'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0),
                                        ),
                                        OutlinedButton(
                                          onPressed: () async {
                                            await FlutterPhoneDirectCaller
                                                .callNumber(phoneNumber);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(phoneNumber,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14.0,
                                                  )),
                                              const Icon(Icons.phone_android,
                                                  color: Colors.green),
                                            ],
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
                        Positioned(
                          left: 10.0,
                          top: 10.0,
                          child: IconButton(
                            onPressed: () {
                              ref
                                  .read(favoriteProvider.notifier)
                                  .delete(value[index]['id']);
                            },
                            icon: toggle
                                ? const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 30.0,
                                  )
                                : const Icon(
                                    Icons.favorite_border,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
  }
}
