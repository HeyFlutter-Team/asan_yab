import 'package:asan_yab/presentation/pages/http_get_post_search.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/place.dart';

final searchUserProvider = FutureProvider<List<Place>>(
    (ref) async => ref.watch(userProvider).getUser());
