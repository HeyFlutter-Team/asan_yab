import 'package:asan_yab/domain/riverpod/data/comments/management_provider.dart';
import 'package:asan_yab/presentation/pages/manage_comments_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/res/image_res.dart';

class Management extends ConsumerStatefulWidget {
  const Management({super.key});

  @override
  ConsumerState<Management> createState() => _ManagementState();
}

class _ManagementState extends ConsumerState<Management> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final languageText = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(languageText!.buttonNvB_5),
        centerTitle: true,
      ),
      body: ref.watch(managementProvider).loading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            )
          : Consumer(builder: (context, ref, child) {
              final managementProviderData = ref.watch(managementProvider);
              return ListView.builder(
                itemCount: managementProviderData.lname.length,
                itemBuilder: (context, index) {
                  final id = ref.watch(managementProvider).ownerList[index];
                  final name = ref.watch(managementProvider).lname[index];
                  final image = ref.watch(managementProvider).lImage[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ManageCommentsPage(
                          postId: id,
                          name: name,
                          image: image,
                        ),
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: screenWidth * 0.25,
                            width: screenWidth * 0.25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) =>
                                        Image.asset(ImageRes.asanYab),
                                    imageUrl:
                                        managementProviderData.lImage[index],
                                    width: double.maxFinite,
                                    height: double.maxFinite,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 12.0, left: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    managementProviderData.lname[index],
                                    overflow: TextOverflow.fade,
                                    maxLines: 2,
                                    style: const TextStyle(fontSize: 18.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
    );
  }
}
