import 'package:asan_yab/core/routes/routes.dart';
import 'package:asan_yab/data/models/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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
            SizedBox(height: 4.h),
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
                  ? context.pushNamed(Routes.searchBar)
                  : null;
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}
