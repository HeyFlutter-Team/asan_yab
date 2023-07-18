import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../model/favorite.dart';
import '../utils/convert_digits_to_farsi.dart';
import '../utils/kcolors.dart';

class FavoriteItem extends StatelessWidget {
  const FavoriteItem({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final items = favorites[index];
        final phoneNumber = convertDigitsToFarsi(items.phone);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Row(
            children: [
              Container(
                height: screenHeight * 0.17,
                width: screenWidth * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(items.image),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 40.0,
                  right: 15.0,
                ),
                child: Column(
                  children: [
                    Text(
                      items.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24.0,
                        fontFamily: 'Persion Font',
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: () async {
                        await FlutterPhoneDirectCaller.callNumber(
                          items.phone,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            phoneNumber,
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 16.0,
                            ),
                          ),
                          const Icon(Icons.call, color: Colors.teal),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
