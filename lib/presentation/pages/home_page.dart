// ignore_for_file: unused_result

import 'dart:async';

import 'package:asan_yab/presentation/widgets/nearby_place.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:new_version_plus/new_version_plus.dart';

import '../../domain/riverpod/data/categories_provider.dart';
import '../../domain/servers/check_new_version.dart';
import '../../domain/servers/nearby_places.dart';
import '../widgets/new_places.dart';
import '../widgets/categories.dart';
import '../widgets/favorites.dart';

import '../widgets/custom_search_bar.dart';

class HomePage extends ConsumerStatefulWidget {
  final bool? isConnected;
  const HomePage({super.key, this.isConnected});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    ref.read(nearbyPlace.notifier).getNearestLocations();
    final newVersion = NewVersionPlus(
      androidId: 'com.heyflutter.asanYab',
      iOSId: 'com.heyflutter.asanYab',
    );

    Timer(const Duration(milliseconds: 800), () {
      checkNewVersion(newVersion, context);
    });
  }

  Future<void> onRefresh() async {
    await Future.delayed(
      const Duration(milliseconds: 100),
    ).then((value) => ref.watch(nearbyPlace.notifier).refresh());
    await ref.read(categoriesProvider.notifier).getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
              const SizedBox(height: 32),
              ref.watch(nearbyPlace).isEmpty
                  ? const SizedBox(height: 0)
                  : const NearbyPlaceWidget(),
              Favorites(isConnected: widget.isConnected!),
            ],
          ),
        ),
      ),
    );
  }
}
