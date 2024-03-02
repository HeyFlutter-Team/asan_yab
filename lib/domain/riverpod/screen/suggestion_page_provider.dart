import 'package:flutter_riverpod/flutter_riverpod.dart';

final isLoading = StateProvider((ref) => false);
final noteProvider =StateProvider<String>((ref) => '');