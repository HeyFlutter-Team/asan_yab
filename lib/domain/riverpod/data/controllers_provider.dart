import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ControllersProvider extends StateNotifier {
  ControllersProvider(super.state);

  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
}

final controllersProvider =
    StateNotifierProvider((ref) => ControllersProvider(ref));
