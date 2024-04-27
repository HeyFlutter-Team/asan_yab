import 'package:asan_yab/domain/riverpod/data/profile_data_provider.dart';
import 'package:asan_yab/presentation/pages/message_page/search_page.dart';
import 'package:asan_yab/presentation/widgets/message/message_home_description.dart';
import 'package:asan_yab/presentation/widgets/message/message_home_list_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/riverpod/data/isOnline.dart';
import '../../../domain/riverpod/data/message/message_stream.dart';

class MessageHome extends ConsumerStatefulWidget {
  const MessageHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MessageHomeState();
}

class _MessageHomeState extends ConsumerState<MessageHome> {
  final userUid = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () async{
        Suspend(ref).suspendUser(context);
        await ref.read(isOnlineUpdateProvider.notifier).isOnlineToTrue();

      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDetailsProvider);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 70),
        child: Card(
          elevation: 4,
          child: AppBar(
            automaticallyImplyLeading: false,
            title: Column(
              children: [
                Text(
                  user?.name != null && user!.name.length > 15
                      ? user.name.substring(0, 15)
                      : user?.name ?? '',
                ),

                const SizedBox(height: 4),
                Text(
                  "${user?.userType} ${AppLocalizations.of(context)!.proFile_type}",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    // user!.invitationRate >= 2
                    //     ?
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SearchPage(),
                            ));
                        // : null;
                  },
                  icon: const Icon(Icons.search)),
            ],
          ),
        ),
      ),
      body: user != null
          // ? user.invitationRate >= 2
              ? const MessageHomeListView()
              // : const MessageHomeDescription()
          : const SizedBox(),
    );
  }
}
