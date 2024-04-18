import 'package:asan_yab/core/extensions/language.dart';
import 'package:asan_yab/core/routes/routes.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/res/image_res.dart';
import '../../data/models/screen_image_view.dart';
import '../../data/repositoris/language_repo.dart';

class PageViewItemWidget extends StatelessWidget {
  final int selectedIndex;
  final List<String> gallery;
  const PageViewItemWidget({
    super.key,
    required this.gallery,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(
        Routes.imageView,
        extra: ScreenImageView(imageList: gallery, index: selectedIndex),
      ),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: CachedNetworkImage(
            imageUrl: gallery[selectedIndex],
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Image.asset(ImageRes.asanYab),
          ),
        ),
      ),
    );
  }
}

class ImageView extends ConsumerStatefulWidget {
  // final int selectedIndex;
  // final List<String?> gallery;
  final ScreenImageView arguments;
  const ImageView({super.key, required this.arguments});

  @override
  ConsumerState<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends ConsumerState<ImageView> {
  late int currentIndex;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.arguments.index);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = ref.watch(languageProvider).code == 'fa';
    return Material(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            loadingBuilder: (context, event) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black,
                  ),
                  LoadingAnimationWidget.fourRotatingDots(
                      color: Colors.redAccent, size: 60),
                ],
              );
            },
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                tightMode: true,
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2.0,
                imageProvider: NetworkImage(widget.arguments.imageList[index]),
              );
            },
            itemCount: widget.arguments.imageList.length,
            pageController: pageController,
            // onPageChanged: onPageChanged,
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
              count: widget.arguments.imageList.length,
              effect: const ScrollingDotsEffect(
                dotHeight: 12,
                dotWidth: 12,
                activeDotColor: Colors.white,
                dotColor: Colors.white30,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 12),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () => context.pop(),
                  icon: Icon(
                    isRTL
                        ? Icons.arrow_back_ios_sharp
                        : Icons.arrow_forward_ios_sharp,
                    color: Colors.white,
                  )),
            ),
          )
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
