import 'package:asan_yab/presentation/pages/personal_information_page.dart';
import 'package:asan_yab/presentation/pages/sign_in_page.dart';
import 'package:asan_yab/presentation/pages/sign_up_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/riverpod/data/auth_page_provider.dart';

class AuthPage extends ConsumerWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLogin = ref.watch(authPageStateProvider);

    return isLogin
        ? const LogInPage()
        :
    SignUpPage(
      onClickedSignIn: () => ref.read(authPageStateProvider.notifier).toggleLoginState(),
    );
  }
}