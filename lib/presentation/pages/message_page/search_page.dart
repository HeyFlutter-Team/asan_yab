import 'package:asan_yab/core/utils/utils.dart';
import 'package:asan_yab/domain/riverpod/config/internet_connectivity_checker.dart';
import 'package:asan_yab/domain/riverpod/data/search_id.dart';
import 'package:asan_yab/presentation/pages/profile/other_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          shadowColor: Colors.white,
          title: TextFormField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              LengthLimitingTextInputFormatter(13),
            ],
            keyboardType: TextInputType.number,
            controller: searchController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: AppLocalizations.of(context)?.searchById,
              hintStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            onChanged: (value) {
              if(ref.watch(internetConnectivityCheckerProvider.notifier).isConnected){
                try {
                  final id = int.parse(value);
                  ref.read(searchProvider.notifier).getProfile(id);

                  if (value.isEmpty) {
                    ref.refresh(searchProvider.notifier).clearSearch();
                  }
                  if (value.isNotEmpty) {
                    ref.refresh(searchLoadingProvider.notifier).state = true;
                  } else {
                    ref.refresh(searchLoadingProvider.notifier).state = false;
                  }
                } catch (e) {
                  print('Error parsing input: $e');
                  // Handle the error here, such as displaying a message to the user
                }
              }else{
                Utils.lostNetSnackBar(context);
              }
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: ref.watch(searchLoadingProvider)
                  ? IconButton(
                      onPressed: () {
                        searchController.clear();
                        ref.refresh(searchProvider.notifier).clearSearch();
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 25.0,
                      ),
                    )
                  : null,
            ),
          ],
          leading: IconButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
              ref.refresh(searchProvider.notifier).clearSearch();
            },
            icon: const Icon(Icons.arrow_back, size: 25.0),
          ),
        ),
        body: ref.watch(searchProvider).isEmpty
            ? Center(
                child: Text(
                AppLocalizations.of(context)!.findingFriendById,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ))
            : ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: ref.watch(searchProvider).length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  // final items = ref.watch(searchTypeSenseProvider);
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  OtherProfile(
                              user: ref.watch(searchProvider)[index],
                              uid:ref.watch(searchProvider)[index].uid! ,
                            ),
                          ));
                    },
                    child: Row(
                      children: [
                        ref.watch(searchProvider)[index].imageUrl == '' ||
                            ref.watch(searchProvider)[index].imageUrl.isEmpty
                            ? const CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    AssetImage('assets/Avatar.png'),
                              )
                            : CircleAvatar(
                                radius: 30,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30)),
                                  child: CachedNetworkImage(
                                    imageUrl: ref
                                        .watch(searchProvider)[index]
                                        .imageUrl,
                                    errorListener: (value) =>  Image.asset(
                                        'assets/Avatar.png'),
                                    placeholder: (context, url) =>  Image.asset(
                                        'assets/Avatar.png'),
                                  ),
                                ),
                              ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            ref.watch(searchProvider)[index].name.length > 15
                                ? ref.watch(searchProvider)[index].name.substring(0, 15)
                                : ref.watch(searchProvider)[index].name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ));
  }
}
