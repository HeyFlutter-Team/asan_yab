import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/riverpod/data/message/message.dart';

class ChatBackgroundWidget extends StatelessWidget {
  const ChatBackgroundWidget({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Container(height: double.infinity,width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(image:AssetImage(ref.watch(wallpaperStateNotifierProvider)),fit: BoxFit.cover )
      ),
    );
  }
}
