import 'package:flutter/material.dart';
import '../database/firebase_helper/place.dart';
import '../widgets/page_view_iten.dart';

class DetailsPage extends StatefulWidget {
  // final Favorite resItem;
  final Place places;
  const DetailsPage({
    super.key,
    required this.places,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final _pageViewController = PageController(viewportFraction: 0.3);
  List<Map<String, dynamic>> dataList = [];

  // void _saveData(Favorite databaseModel) async {
  //   await DatabaseHelper.insertUser(databaseModel);
  // }
  //
  // void _delete(int docId) async {
  //   await DatabaseHelper.deleteData(docId);
  //   List<Map<String, dynamic>> updatedData = await DatabaseHelper.getData();
  //   setState(() {
  //     dataList = updatedData;
  //   });
  // }
  //
  // void _fetchUser() async {
  //   List<Map<String, dynamic>> userList = await DatabaseHelper.getData();
  //   setState(() {
  //     dataList = userList;
  //   });
  // }

  @override
  void initState() {
    // _fetchUser();
    super.initState();
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<FavoriteProvider>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor:Theme.of(context).primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 30,
                  ),
                  iconSize: 25,
                ),
                IconButton(
                  onPressed: () {
                    // provider.toggleFavorite(widget.resItem.name);
                    //
                    // if (provider.isExist(widget.resItem.name)) {
                    //   _saveData(widget.resItem);
                    // } else {
                    //   _delete(dataList[0]['name']);
                    // }
                  },
                  icon: true
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
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      width: size.width,
                      height: size.height * 0.3,
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
                        // image:  DecorationImage(
                        //     fit: BoxFit.fitWidth,
                        // Image.network("${widget.places.coverImage}",
                        //     image: AssetImage('${widget.places.coverImage}')),
                      ),
                      child: Image(
                        image: NetworkImage("${widget.places.coverImage}"),
                        fit: BoxFit.cover,
                        ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: RichText(
                      text: TextSpan(
                          text: widget.places.name,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text:
                                  '\n\n bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss ${widget.places.description}\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blueGrey.withOpacity(0.7),
                              ),
                            ),
                            TextSpan(
                              text:
                                  '\n ${widget.places.adresses[0].phone[0]}',
                              style: TextStyle(
                                color: Colors.blueGrey.withOpacity(0.7),
                              ),
                            ),
                            TextSpan(
                              text: '\n${widget.places.adresses[0].address}',
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.7),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            )
                          ]),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.25,
                    child: PageView.builder(
                      controller: _pageViewController,
                      itemCount: widget.places.gallery.length,
                      padEnds: false,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(6),
                          child: PageViewItem(
                              selectedIndex: index,
                              gallery: widget.places.gallery),
                        );
                      },
                    ),
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
