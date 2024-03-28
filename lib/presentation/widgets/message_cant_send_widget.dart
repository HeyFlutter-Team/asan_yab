import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/convert_digits_to_farsi.dart';
import '../../data/models/users.dart';
import '../../domain/riverpod/data/profile_data_provider.dart';

class MessageCantSendWidget extends StatelessWidget {
  const MessageCantSendWidget({
    super.key,
    required this.text,
    required this.isRTL,
    required this.user,
    required this.ref,
  });

  final AppLocalizations text;
  final bool isRTL;
  final Users? user;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.chat,
                size: 80,
                color: Colors.red.shade800,
              ),
              Text(
                text.chat_message,
                style: TextStyle(
                  color: Colors.red.shade800,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Text(
            text.chat_screen,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text.message_personal_score,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                isRTL
                    ? convertDigitsToFarsi('  ${user!.invitationRate}')
                    : '  ${user!.invitationRate}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              )
            ],
          ),
          Container(
            height: 420,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/message_box.png'),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Text(
                    text.message_description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 19),
                  ),
                  const SizedBox(height: 10),
                  isRTL
                      ? Container(
                          height: 100,
                          width: 260,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/newMessage.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          height: 90,
                          width: 300,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/message_5.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(text.message_your_id),
                      const SizedBox(width: 10),
                      Container(
                        height: 40,
                        color: Colors.red.shade800.withOpacity(0.5),
                        child: Center(
                          child: TextButton(
                            child: Text(isRTL
                                ? convertDigitsToFarsi('${user!.id}')
                                : '${user!.id}'),
                            onPressed: () {
                              ref
                                  .read(profileDetailsProvider.notifier)
                                  .copyToClipboard('${user!.id}');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(text.profile_copy_id_snack_bar),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
