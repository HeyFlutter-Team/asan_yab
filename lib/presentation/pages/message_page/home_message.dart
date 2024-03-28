import 'package:asan_yab/core/extensions/language.dart';

import 'package:asan_yab/domain/riverpod/data/message/message_history.dart';
import 'package:asan_yab/domain/riverpod/data/message/seen_message.dart';
import 'package:asan_yab/domain/riverpod/data/message/messages_notifier.dart';

import 'package:asan_yab/domain/riverpod/data/profile_data_provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/translation_util.dart';
import '../../../data/repositoris/language_repo.dart';
import '../../../domain/riverpod/data/message/message_suspend.dart';
import '../../widgets/message_app_bar_widget.dart';
import '../../widgets/message_can_send_widget.dart';
import '../../widgets/message_cant_send_widget.dart';

class HomeMessage extends ConsumerStatefulWidget {
  const HomeMessage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MessageHomeState();
}

class _MessageHomeState extends ConsumerState<HomeMessage> {
  final userUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      MessageSuspend(ref).suspendUser(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final messageNotifier = ref.watch(messageHistory);
    final messageDetails = ref.watch(messageNotifierProvider);
    final user = ref.watch(profileDetailsProvider);
    final newMessage = ref.watch(seenMassageProvider);
    final text = texts(context);
    final isRTL = ref.watch(languageProvider).code == 'fa';
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 70),
        child: MessageAppBarWidget(user: user, text: text),
      ),
      body: user != null
          ? user.invitationRate >= 2
              ? MessageCanSendWidget(
                  messageNotifier: messageNotifier,
                  messageDetails: messageDetails,
                  ref: ref,
                  newMessage: newMessage,
                )
              : MessageCantSendWidget(
                  text: text,
                  isRTL: isRTL,
                  user: user,
                  ref: ref,
                )
          : const Text('null'),
    );
  }
}
