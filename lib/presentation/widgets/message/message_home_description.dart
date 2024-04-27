import 'package:asan_yab/data/models/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/convert_digits_to_farsi.dart';
import '../../../data/repositoris/language_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/riverpod/data/profile_data_provider.dart';

class MessageHomeDescription extends ConsumerWidget {
  const MessageHomeDescription({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final languageText = AppLocalizations.of(context);
    final isRTL = ref.watch(languageProvider).code == 'fa';
    final themDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(userDetailsProvider);
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
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
                languageText!.chat_message,
                style: TextStyle(
                    color: Colors.red.shade800,
                    fontSize: 48,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Text(
            languageText.chat_screen,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 23, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                languageText.message_personal_score,
                style: const TextStyle(
                    fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(
                width: 2,
              ),
              Text(
                isRTL
                    ? convertDigitsToFarsi(
                    '  ${user?.invitationRate}')
                    : '  ${user?.invitationRate}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 5),
            child: Container(
              height: 420,
              width: double.infinity,
              decoration: BoxDecoration(
                  color:themDark? Colors.grey.shade800:Colors.grey.shade600,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(52),
                    bottomLeft: Radius.circular(52),
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    Text(
                      languageText.message_description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 19, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    isRTL
                        ? Container(
                      height: 100,
                      width: 260,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/newMessage.png'),
                              fit: BoxFit.cover)),
                    )
                        : Container(
                      height: 90,
                      width: 300,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/message_5.png'),
                              fit: BoxFit.cover)),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        ref
                            .read(
                            userDetailsProvider.notifier)
                            .copyToClipboard('${user?.id}');
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          SnackBar(
                            content: Text(languageText
                                .profile_copy_id_snack_bar),
                            duration:
                            const Duration(seconds: 2),
                          ),
                        );
                      },

                      child: Container(
                        decoration:  BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: Colors.red.shade900,
                        ),
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              languageText.message_your_id,
                              style: const TextStyle(color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 5,),
                            const Text('=',style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),),
                            const SizedBox(width: 5,),
                            Text(
                                isRTL
                                    ? convertDigitsToFarsi(
                                    '${user?.id}')
                                    : '${user?.id}',
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),


                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 30,)
        ],
      ),
    );
  }
}
