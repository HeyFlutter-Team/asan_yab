import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/riverpod/data/profile_data_provider.dart';

class ShowProfilePage extends ConsumerStatefulWidget {
  final String imagUrl;
  final bool isEditing;
  const ShowProfilePage({super.key, required this.imagUrl, this.isEditing=false});

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
    return Scaffold(
      appBar:
      AppBar(
        actions: [
          widget.isEditing? IconButton(
              onPressed: () async{
              await  ref
                    .read(deleteProfile.notifier)
                    .deleteImageAndClearUrl(widget.imagUrl)
                    .whenComplete((){
                Navigator.pop(context);
                      debugPrint('younis image deleted');
                });
              },
              icon: const Icon(Icons.delete))
      :const PreferredSize(preferredSize: Size(0, 0), child: SizedBox()),
        ],
      ),
      body: Center(
        child: Hero(tag: 'avatarHeroTag', child: Image.network(widget.imagUrl)),
      ),
    );
  }
}
