import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

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
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageView(
                selectedIndex: selectedIndex,
                gallery: gallery,
              ),
            ));
      },
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

class ImageView extends StatefulWidget {
  final int selectedIndex;
  final List<String?> gallery;
  const ImageView({
    super.key,
    required this.selectedIndex,
    required this.gallery,
  });

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageController = PageController(initialPage: widget.selectedIndex);
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.gallery.length,
            itemBuilder: (context, index) {
              currentIndex = index;
              return Center(
                child: PhotoView(
                  maxScale: 3.0,
                  minScale: 0.5,
                  imageProvider: NetworkImage(widget.gallery[currentIndex]!),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SmoothPageIndicator(
              onDotClicked: (index) {
                pageController.animateToPage(index,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.bounceIn);
              },
              controller: pageController,
              count: widget.gallery.length,
              effect: const WormEffect(
                  dotHeight: 12,
                  dotWidth: 12,
                  type: WormType.thinUnderground,
                  activeDotColor: Colors.white,
                  dotColor: Colors.white30),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconForPage(
              pageController: pageController,
              movePage: () {
                debugPrint('Ramin: $currentIndex');
                if (currentIndex == 0) {
                  pageController.animateToPage(
                    widget.gallery.length,
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeIn,
                  );
                } else {
                  pageController.previousPage(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeIn,
                  );
                }
              },
              icon: Icons.arrow_back_ios_sharp,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: IconForPage(
              pageController: pageController,
              icon: Icons.arrow_forward_ios_sharp,
              movePage: () {
                debugPrint('Ramin1: $currentIndex');
                if (currentIndex + 1 == widget.gallery.length) {
                  pageController.animateToPage(
                    0,
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeIn,
                  );
                } else {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeIn,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class IconForPage extends StatelessWidget {
  final IconData icon;
  final VoidCallback movePage;
  const IconForPage({
    super.key,
    required this.pageController,
    required this.icon,
    required this.movePage,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
          color: Colors.blueGrey.withOpacity(0.7), shape: BoxShape.circle),
      child: IconButton(
        icon: Icon(icon),
        onPressed: movePage,
        iconSize: 30,
      ),
    );
  }
}
