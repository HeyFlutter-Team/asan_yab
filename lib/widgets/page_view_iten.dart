import 'package:flutter/material.dart';

import '../models/restaurant_models.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PageViewItem extends StatelessWidget {
  final int selectedIndex;
  const PageViewItem({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showBottomSheet(
          context: context,
          builder: (context) => ImageView(selectedIndex: selectedIndex)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image.asset(
          images[selectedIndex],
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class ImageView extends StatelessWidget {
  final int selectedIndex;

  const ImageView({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final _pageController = PageController(initialPage: selectedIndex);
    return Stack(
      alignment: Alignment.bottomCenter,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // mainAxisSize: MainAxisSize.max,
      children: [
        PageView.builder(
          padEnds: false,
          controller: _pageController,
          itemCount: images.length,
          itemBuilder: (context, index) => Image.asset(
            images[index],
            fit: BoxFit.cover,
            width: size.width,
            height: size.height,
          ),
        ),
        // const SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: SmoothPageIndicator(
            controller: _pageController,
            count: images.length,
            effect: const WormEffect(
                dotHeight: 16,
                dotWidth: 16,
                type: WormType.thinUnderground,
                activeDotColor: Colors.amber,
                dotColor: Colors.cyanAccent),
          ),
        ),

        // ElevatedButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     style: ElevatedButton.styleFrom(
        //         shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(20)),
        //         backgroundColor: Colors.blueGrey,
        //         minimumSize: const Size(double.maxFinite, 55)),
        //     child: const Row(
        //       children: [
        //         Icon(Icons.arrow_back_ios_sharp),
        //         SizedBox(width: 3),
        //         Text('Back')
        //       ],
        //     )),
      ],
    );
  }
}
