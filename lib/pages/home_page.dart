import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_version_plus/new_version_plus.dart';

import '../constants/kcolors.dart';

import '../widgets/new_places.dart';
import '../widgets/categories.dart';
import '../widgets/favorites.dart';

import '../widgets/custom_search_bar.dart';
import '../widgets/updatedialog.dart';

class HomePage extends StatefulWidget {
  final bool? isConnected;
  const HomePage({super.key, this.isConnected});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final newVersion = NewVersionPlus(
      androidId: 'com.heyflutter.asanYab',
      iOSId: 'com.heyflutter.asanYab',
    );

    Timer(const Duration(milliseconds: 800), () {
      checkNewVersion(newVersion);
    });

    onRefresh();
  }

//hello test for update with github
  // fixed
  Future<void> checkNewVersion(NewVersionPlus newVersion) async {
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

  Future<void> onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0.0,
        title: const CustomSearchBar(),
      ),
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              NewPlaces(onRefresh: onRefresh),
              const SizedBox(height: 32),
              widget.isConnected!
                  ? Categories(onRefresh: onRefresh)
                  : const SizedBox(),
              Favorites(isConnected: widget.isConnected!),
            ],
          ),
        ),
      ),
    );
  }
}
