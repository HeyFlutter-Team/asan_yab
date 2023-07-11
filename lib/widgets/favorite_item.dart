import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../model/favorite.dart';

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
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: screenHeight * 0.2,
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
                  top: 50.0,
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
                    ElevatedButton.icon(
                      onPressed: () async {
                        await FlutterPhoneDirectCaller.callNumber(items.phone);
                      },
                      icon: const Icon(
                        Icons.call,
                        color: Colors.green,
                        size: 24.0,
                      ),
                      label: Text(items.phone),
                    )
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
