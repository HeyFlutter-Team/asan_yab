import 'package:asan_yab/domain/riverpod/data/profile_data_provider.dart';
import 'package:asan_yab/presentation/pages/message_page/chat_page.dart';
import 'package:asan_yab/presentation/pages/message_page/search_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageHome extends ConsumerStatefulWidget {
  const MessageHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MessageHomeState();
}

class _MessageHomeState extends ConsumerState<MessageHome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDetailsProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Text(user!.name),
            const SizedBox(height: 4),
            Text(
              "${user.userType} ${AppLocalizations.of(context)!.proFile_type}",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchPage(),
                    ));
              },
              icon: const Icon(Icons.search)),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessagePage(),
                          ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.red,
                                  Colors.green,
                                  Colors.brown,
                                  Colors.black,
                                  Colors.white
                                ], // Replace with your gradient colors
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(
                                color: Colors.transparent,
                                width: 2.5,
                              ),
                            ),
                            child: Container(
                              padding: EdgeInsets.zero,
                              margin: EdgeInsets.zero,
                              width: 65.0,
                              height: 65.0,
                              decoration: BoxDecoration(
                                color: const Color(0xff7c94b6),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      user!.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: ListTile(
                            title: Text(user.name),
                            subtitle: Text('Last massege'),
                            trailing: Text('last seen'),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
