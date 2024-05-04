import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/riverpod/data/message/message.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WallPaperPage extends ConsumerStatefulWidget {
  const WallPaperPage({super.key});

  @override
  ConsumerState<WallPaperPage> createState() => _WallPaperPageState();
}

class _WallPaperPageState extends ConsumerState<WallPaperPage> {
  @override
  Widget build(BuildContext context) {
    final languageText = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title:  Text('${languageText?.profile_wall_paper}'),
        centerTitle: true,
      ),
      body: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 12.0,
          mainAxisExtent: 230.0,
        ),
        itemCount: chatWallpapersList.length,
        itemBuilder: (context, index) {
          final selectedWallpaper =
          ref.watch(wallpaperStateNotifierProvider);
          final chatWallPapers = chatWallpapersList[index];
          return InkWell(
            onTap: ()async {
              String wallpaperPath = chatWallPapers;
              await ref
                  .read(wallpaperStateNotifierProvider.notifier)
                  .saveWallpaperPath(wallpaperPath);
            },
            child: Stack(
              children: [
                SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: Image.asset(chatWallPapers,fit: BoxFit.cover,),
                ),
                selectedWallpaper == chatWallPapers?
                    Container(
                      color: Colors.grey.withOpacity(0.4),
                    )
                    :const SizedBox(),
                selectedWallpaper == chatWallPapers?
                const Align(
                    alignment: Alignment.center,
                    child: Icon(Icons.check,size: 60,))
                    :const SizedBox()
              ],
            ),
          );

        },

      ),
    );
  }
  final List<String> chatWallpapersList=[
    'assets/wallpaper_1_main.jpg',
    'assets/wallpaper_2_main.jpg',
    'assets/wallpaper_3_main.jpg',
    'assets/wallpaper_4_main.jpg',
    'assets/wallpaper_5_main.jpg',
    'assets/wallpaper_6_main.jpg',
    'assets/wallpaper_7_main.jpg',
    'assets/wallpaper_8_main.jpg',
    'assets/wallpaper_9_main.jpg',
    'assets/wallpaper_10_main.jpg',
    'assets/wallpaper_11_main.jpg',
    'assets/wallpaper_12_main.jpg',
    'assets/wallpaper_13_main.jpg',
    'assets/wallpaper_14_main.jpg',
    'assets/wallpaper_15_main.jpg',
    'assets/wallpaper_16_main.jpg',
    'assets/wallpaper_17_main.jpg',
    'assets/wallpaper_18_main.jpg',
    'assets/wallpaper_19_main.jpg',
    'assets/wallpaper_20_main.jpg',
    'assets/wallpaper_21_main.jpg',
    'assets/wallpaper_22_main.jpg',
    'assets/wallpaper_23_main.jpg',
    'assets/wallpaper_24_main.jpg',
    'assets/wallpaper_25_main.jpg',
    'assets/wallpaper_26_main.jpg',
    'assets/wallpaper_27_main.jpg',
    'assets/wallpaper_28_main.jpg',
    'assets/wallpaper_29_main.jpg',
  ];
}
