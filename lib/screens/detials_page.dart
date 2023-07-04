import 'package:details/models/restaurant_models.dart';
import 'package:flutter/material.dart';

import '../widgets/page_view_iten.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final _pageViewController = PageController(viewportFraction: 0.3);

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_back_ios),
                    iconSize: 18),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_border),
                    iconSize: 18),
              ],
            ),
            Container(
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
                image: const DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: AssetImage('assets/images/restaurant.jpg')),
              ),
            ),
            const SizedBox(height: 30),
            RichText(
              text: TextSpan(
                  text: 'Name of resturant',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: '\n\n description restaurant\n',
                      style: TextStyle(
                        color: Colors.blueGrey.withOpacity(0.7),
                      ),
                    ),
                    TextSpan(
                      text: '\n Phone restaurant',
                      style: TextStyle(
                        color: Colors.blueGrey.withOpacity(0.7),
                      ),
                    ),
                  ]),
            ),
            SizedBox(
              height: size.height * 0.25,
              child: PageView.builder(
                controller: _pageViewController,
                itemCount: images.length,
                padEnds: false,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: PageViewItem(imgUrl: images[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Address of place :',
              style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 3,
                  minimumSize: const Size(double.maxFinite, 55),
                  backgroundColor: Colors.blueGrey),
              child: const Row(
                children: [
                  Text('Find the address in google map'),
                  SizedBox(width: 5),
                  Icon(Icons.map),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
