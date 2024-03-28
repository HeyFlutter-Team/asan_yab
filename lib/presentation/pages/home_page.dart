// ignore_for_file: unused_result

import 'dart:async';

import 'package:asan_yab/presentation/widgets/nearby_place_widget.dart';
import 'package:asan_yab/presentation/widgets/new_places_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_version_plus/new_version_plus.dart';

import '../../domain/riverpod/data/categories_provider.dart';
import '../../domain/riverpod/data/update_favorite_provider.dart';
import '../../domain/servers/check_new_version.dart';
import '../../domain/servers/nearby_places.dart';
import '../widgets/categories_widget.dart';
import '../widgets/custom_search_bar_widget.dart';
import '../widgets/favorite_widget.dart';

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
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        if (mounted) {
          if (mounted) {
            final newVersion = NewVersionPlus(
              androidId: 'com.heyflutter.asanYab',
              iOSId: 'com.heyflutter.asanYab',
            );
            Timer(const Duration(seconds: 800),
                () => checkNewVersion(newVersion, context));
          }
        }
      },
    );
  }

  Future<void> onRefresh() async {
    await ref.refresh(updateFavoriteProvider.notifier).update(context, ref);
    await Future.delayed(
      const Duration(milliseconds: 100),
    ).then((value) => ref.watch(nearbyPlace.notifier).refresh());
    await ref.read(categoriesProvider.notifier).getCategories();
  }

  @override
  Widget build(BuildContext context) {
    bool isLogin = FirebaseAuth.instance.currentUser != null;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: const CustomSearchBarWidget(),
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
              NewPlacesWidget(onRefresh: onRefresh),
              const SizedBox(height: 32),
              widget.isConnected!
                  ? CategoriesWidget(onRefresh: onRefresh)
                  : const SizedBox(),
              const SizedBox(height: 32),
              ref.watch(nearbyPlace).isEmpty
                  ? const SizedBox(height: 0)
                  : const NearbyPlaceWidget(),
              isLogin
                  ? FavoriteWidget(isConnected: widget.isConnected!)
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
