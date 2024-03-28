import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../domain/riverpod/screen/botton_navigation_provider.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({
    super.key,
    required this.ref,
    required this.context,
  });

  final WidgetRef ref;
  final BuildContext context;

  @override
  Widget build(BuildContext context) => BottomNavigationBar(
        selectedFontSize: 18.0,
        unselectedFontSize: 14.0,
        currentIndex: ref.watch(buttonNavigationProvider),
        selectedItemColor: Colors.red,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          FocusScope.of(context).unfocus();
          ref.read(buttonNavigationProvider.notifier).selectedIndex(index);
        },
        // backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.buttonNvB_1,
            icon: const Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.buttonNvB_2,
            icon: const Icon(Icons.place),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.buttonNvB_3,
            icon: const Icon(Icons.message),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.buttonNvB_4,
            icon: const Icon(Icons.person),
          ),
        ],
      );
}
