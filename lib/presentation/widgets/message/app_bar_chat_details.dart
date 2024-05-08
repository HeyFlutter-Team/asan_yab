import 'package:asan_yab/presentation/pages/profile/other_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji_gif_picker/flutter_emoji_gif_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:popover/popover.dart';
import '../../../data/models/users.dart';
import 'dart:ui' as ui;
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../domain/riverpod/data/message/message.dart';

class AppBarChatDetails extends ConsumerWidget implements PreferredSizeWidget {
  const AppBarChatDetails({
    required this.urlImage,
    required this.name,
    required this.isOnline,
    required this.employee,
    required this.userId,
    required this.user,
    super.key,
  });

  final String urlImage;
  final String name;
  final bool isOnline;
  final String employee;
  final String userId;
  final Users user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themDark = Theme.of(context).brightness == Brightness.dark;

    if (context.findRenderObject() == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          ref.read(loadingIconChat.notifier).state = false;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtherProfile(
                isFromChat: true,
                uid: userId,
                user: user,
              ),
            ),
          );
        },
        child: AppBar(
          elevation: 1,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(right: 10,),
              child: Directionality(
                textDirection: ui.TextDirection.ltr,
                child: Row(
                  children: [
                    Row(
                      children: <Widget>[
                        IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                          FocusScope.of(context).unfocus();
                          if(ref.watch(emojiShowingProvider) || ref.watch(gifShowingProvider)){
                            ref.read(emojiShowingProvider.notifier).state=false;
                            ref.read(gifShowingProvider.notifier).state=false;
                          }
                          EmojiGifPickerPanel.onWillPop();

                          Navigator.pop(context);
                        }, icon: const Icon(Icons.arrow_back_ios,size: 25,)),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          name.length > 15 ? name.substring(0, 15) : name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 3.0),
                              child: Icon(
                                Icons.circle,
                                color: isOnline ? Colors.green : Colors.grey,
                                size: 12,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              isOnline ? 'Online' : 'Offline',
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onLongPress: () {
                            showPopover(
                              context: context,
                              bodyBuilder: (context) {
                                return Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context).size.height * 0.46,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(62.0),
                                            ),
                                            child: user.imageUrl.isNotEmpty ||
                                                    user.imageUrl != ''
                                                ? CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl: user.imageUrl,
                                                    placeholder: (context, url) =>
                                                        Center(
                                                          child: Center(
                                                            child:
                                                                LoadingAnimationWidget
                                                                    .twistingDots(
                                                              leftDotColor: const Color(
                                                                  0xFF1A1A3F),
                                                              rightDotColor:
                                                                  const Color(
                                                                      0xFFEA3799),
                                                              size: 200,
                                                            ),
                                                          ),
                                                        ))
                                                : Image.asset('assets/avatar.jpg')),
                                        const SizedBox(height: 2,),
                                      ],
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.4),
                                            borderRadius: const BorderRadius.all(Radius.circular(12))
                                        ),
                                        height: 55,
                                        width: 180,
                                        child: PopupMenuItem(
                                          onTap: () {
                                            ref.read(loadingIconChat.notifier).state = false;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => OtherProfile(
                                                  isFromChat: true,
                                                  uid: userId,
                                                  user: user,
                                                ),
                                              ),
                                            );
                                          },
                                          child: const ListTile(
                                            title: Text(
                                              'Open',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                            trailing: Icon(
                                              Icons.info_outline,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              onPop: () => print('Popover was popped!'),
                              direction: PopoverDirection.top,
                              backgroundColor: Colors.transparent,
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height * 0.55,
                              arrowHeight: 15,
                              barrierColor: Colors.transparent.withOpacity(0.8),
                            );
                          },
                          child: urlImage == ''
                              ? const CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/avatar.jpg'),
                                  maxRadius: 20,
                                )
                              : CircleAvatar(
                                  maxRadius: 20,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30)),
                                    child: CachedNetworkImage(
                                      imageUrl: urlImage,
                                      placeholder: (context, url) =>
                                          Image.asset('assets/avatar.jpg'),
                                      errorListener: (value) =>
                                          Image.asset('assets/avatar.jpg'),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

final loadingIconChat = StateProvider((ref) => true);