
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import '../model/favorite.dart';
import '../utils/convert_digits_to_farsi.dart';
import '../utils/kcolors.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
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
        itemCount: 0,
        itemBuilder: (context, index) {
          final items = favorites[index];
          final phoneNumber = convertDigitsToFarsi(items.phone);
          return Stack(
            children: [
              Card(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: kPrimaryColor,
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
                            image: AssetImage(items.image),
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
                        padding: const EdgeInsets.symmetric(horizontal:12),
                        child: Column(
                          children: [
                            Text(
                              items.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  const TextStyle(color: Colors.black, fontSize: 20.0),
                            ),
                            OutlinedButton(
                              onPressed: () async {
                                await FlutterPhoneDirectCaller.callNumber(
                                    items.phone);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    phoneNumber,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  const Icon(Icons.phone_android, color: Colors.teal),
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
              Positioned(
                left: 10.0,
                top: 10.0,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.favorite_border,
                    color: kPrimaryColor,
                    size: 30.0,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
