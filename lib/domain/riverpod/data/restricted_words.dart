import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'restricted_words.g.dart';

@riverpod
List<String> restrictedWord(RestrictedWordRef ref) => ['مراکز خریداری'];
