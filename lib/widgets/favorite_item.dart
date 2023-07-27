import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';
import '../providers/lazy_loading_provider.dart';
import '../constants/kcolors.dart';
import '../database/firebase_helper/place.dart';
import '../pages/detials_page.dart';
import '../utils/convert_digits_to_farsi.dart';

class FavoriteItem extends StatefulWidget {
  final String categoryNameCollection;
  final String id;
  const FavoriteItem({
    Key? key,
    required this.categoryNameCollection,
    required this.id,
  }) : super(key: key);

  @override
  State<FavoriteItem> createState() => _FavoriteItemState();
}

class _FavoriteItemState extends State<FavoriteItem> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.width;
    final lazyLoading = Provider.of<LazyLoadingProvider>(context);
    return FutureBuilder<List<Place>>(
      future: lazyLoading.fetchDataFromFirebase(widget.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(
                top: 350,
              ),
              child: Text(
                '........Loading',
                style: TextStyle(fontSize: 20),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          final data = snapshot.data ?? [];
          return ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              final phone = data[index].adresses[0].phone;
              final phoneNumber = convertDigitsToFarsi(phone!);
              final items = data[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 30.0, horizontal: 15.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsPage(
                              id: data[index].id,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: screenHeight * 0.3,
                        width: screenWidth * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage('${items.logo}'),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.black.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 10.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            items.name!,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20.0),
                          ),
                          const SizedBox(height: 12.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black.withOpacity(0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            onPressed: () async {
                              await FlutterPhoneDirectCaller.callNumber(
                                  phoneNumber);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  phoneNumber,
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 20.0,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.phone_android,
                                  color: Colors.green,
                                  size: 25,
                                ),
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
        return const SizedBox(height: 0);
      },
    );
  }
}
