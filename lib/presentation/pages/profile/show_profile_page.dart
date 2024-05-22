import 'package:asan_yab/core/utils/utils.dart';
import 'package:asan_yab/domain/riverpod/config/internet_connectivity_checker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/riverpod/data/profile_data_provider.dart';

class ShowProfilePage extends ConsumerStatefulWidget {
  final String imagUrl;
  final bool isEditing;
  const ShowProfilePage(
      {super.key, required this.imagUrl, this.isEditing = false});

  @override
  ConsumerState<ShowProfilePage> createState() => _ShowProfilePageState();
}

class _ShowProfilePageState extends ConsumerState<ShowProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.watch(userDetailsProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity! > 10) {
          Navigator.of(context).pop();
        }},
      child: Scaffold(
        appBar: AppBar(
          actions: [
            widget.isEditing
                ? IconButton(
                    onPressed: () async {
                     if(Utils.netIsConnected(ref)){
                       await ref
                           .read(deleteProfile.notifier)
                           .deleteImageAndClearUrl(widget.imagUrl)
                           .whenComplete(() async {
                         await ref
                             .watch(userDetailsProvider.notifier)
                             .getCurrentUserData();
                         debugPrint('younis image deleted');
                       }).whenComplete(() => Navigator.pop(context));
                     }else{
                       Utils.lostNetSnackBar(context);
                     }
                    },
                    icon: const Icon(Icons.delete))
                : const PreferredSize(
                    preferredSize: Size(0, 0), child: SizedBox()),
          ],
        ),
        body: Center(
          child: Hero(
            tag: 'avatarHeroTag',
            child: CachedNetworkImage(
              imageUrl: widget.imagUrl,
              placeholder: (context, url) => Image.asset('assets/Avatar.png'),
              errorListener: (value) => Image.asset('assets/Avatar.png'),
            ),
          ),
        ),
      ),
    );
  }
}
