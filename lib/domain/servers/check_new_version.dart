import 'package:flutter/material.dart';
import 'package:new_version_plus/new_version_plus.dart';

import '../../presentation/widgets/updatedialog.dart';

Future<void> checkNewVersion(
    NewVersionPlus newVersion, BuildContext context) async {
  final status = await newVersion.getVersionStatus();
  if (status != null) {
    if (status.canUpdate) {
      if (context.mounted) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: UpdateDialog(
                allowDismissal: false,
                description: status.releaseNotes!,
                version: status.storeVersion,
                appLink: status.appStoreLink,
              ),
            );
          },
        );
      }
    }
  }
}
