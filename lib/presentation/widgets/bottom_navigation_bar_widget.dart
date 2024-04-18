import 'package:asan_yab/core/utils/translation_util.dart';
import 'package:asan_yab/domain/riverpod/screen/botton_navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({
    super.key,
    required this.ref,
    required this.context,
  });

  final WidgetRef ref;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final text = texts(context);
    return BottomNavigationBar(
      selectedFontSize: 18.0,
      unselectedFontSize: 14.0,
      currentIndex: ref.watch(stateButtonNavigationBarProvider),
      selectedItemColor: Colors.red,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        FocusScope.of(context).unfocus();
        ref
            .read(stateButtonNavigationBarProvider.notifier)
            .selectedIndex(index);
      },
      items: [
        BottomNavigationBarItem(
          label: text.buttonNvB_1,
          icon: const Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: text.buttonNvB_2,
          icon: const Icon(Icons.place),
        ),
        BottomNavigationBarItem(
          label: text.buttonNvB_3,
          icon: const Icon(Icons.message),
        ),
        BottomNavigationBarItem(
          label: text.buttonNvB_4,
          icon: const Icon(Icons.person),
        ),
      ],
    );
  }
}
