import 'package:asan_yab/data/models/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../pages/search_bar_page.dart';

class MessageAppBarWidget extends StatelessWidget {
  const MessageAppBarWidget({
    super.key,
    required this.user,
    required this.text,
  });

  final Users? user;
  final AppLocalizations text;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Text('${user?.name}'),
            const SizedBox(height: 4),
            Text(
              "${user?.userType} ${text.proFile_type}",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              user!.invitationRate >= 2
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchBarPage(),
                      ),
                    )
                  : null;
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}
