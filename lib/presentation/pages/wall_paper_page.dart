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
    'assets/wallPaper1-min.jpg',
    'assets/wallPaper2-min.jpg',
    'assets/wallPaper3-min.jpg',
    'assets/wallPaper4-min.jpg',
    'assets/wallPaper5-min.jpg',
    'assets/wallPaper7-min.jpg',
    'assets/wallPaper8-min.jpg',
    'assets/wallPaper9-min.jpg',
    'assets/wallPaper10-min.jpg',
    'assets/wallPaper11-min.jpg',
    'assets/wallPaper12-min.jpg',
    'assets/wallPaper13-min.jpg',
    'assets/wallPaper14-min.jpg',
    'assets/wallPaper15-min.jpg',
    'assets/wallPaper16-min.jpg',
    'assets/wallPaper17-min.jpg',
    'assets/wallPaper18-min.jpg',
    'assets/wallPaper19-min.jpg',
    'assets/wallPaper20-min.jpg',
    'assets/wallPaper21-min.jpg',
    'assets/wallPaper22-min.jpg',
    'assets/wallPaper23-min.jpg',
    'assets/wallPaper24-min.jpg',
    'assets/wallPaper25-min.jpg',
    'assets/wallPaper26-min.jpg',
    'assets/wallPaper27-min.jpg',
    'assets/wallPaper28-min.jpg',
    'assets/wallPaper29-min.jpg',
    'assets/wallPaper30-min.jpg',
  ];
}
