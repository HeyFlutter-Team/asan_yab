import 'package:flutter/material.dart';


import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PageViewItem extends StatelessWidget {
  final int selectedIndex;
  final List<String?> gallery;
  const PageViewItem({
    super.key,
    required this.gallery,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showBottomSheet(
          context: context,
          builder: (context) => ImageView(
                selectedIndex: selectedIndex,
                gallery: gallery,
              )),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.network(
            gallery[selectedIndex]!,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class ImageView extends StatelessWidget {
  final int selectedIndex;
  final List<String?> gallery;
  const ImageView(
      {super.key, required this.selectedIndex, required this.gallery});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final pageController = PageController(initialPage: selectedIndex);
    return Stack(
      alignment: Alignment.bottomCenter,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // mainAxisSize: MainAxisSize.max,
      children: [
        PageView.builder(
          padEnds: false,
          controller: pageController,
          itemCount: gallery.length,
          itemBuilder: (context, index) => InteractiveViewer(
            // constrained: false,
            child: Image.network(
              gallery[index]!,
              fit: BoxFit.contain,
              width: size.width,
              height: size.height,
            ),
          ),
        ),
        // const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SmoothPageIndicator(
            controller: pageController,
            count: gallery.length,
            effect: const WormEffect(
                dotHeight: 12,
                dotWidth: 12,
                type: WormType.thinUnderground,
                activeDotColor: Colors.white,
                dotColor: Colors.white30),
          ),
        ),
      ],
    );
  }
}
