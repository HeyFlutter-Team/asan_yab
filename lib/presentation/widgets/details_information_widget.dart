import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/convert_digits_to_farsi.dart';
import '../../data/models/place.dart';
import 'custom_cards_widget.dart';

class DetailsInformationWidget extends StatelessWidget {
  const DetailsInformationWidget({
    super.key,
    required this.text,
    required this.places,
    required this.phoneData,
    required this.addressData,
    required this.isRTL,
  });

  final AppLocalizations text;
  final Place? places;
  final List<String> phoneData;
  final List<String> addressData;
  final bool isRTL;

  @override
  Widget build(BuildContext context) {
    return CustomCardsWidget(
      title: text.details_page_3_custom_card,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: places!.addresses.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          phoneData.add(places!.addresses[index].phone);
          addressData.add(
              '${places!.addresses[index].branch}: ${places!.addresses[index].address}');
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: (places!.addresses[index].address.isEmpty)
                    ? SizedBox(height: 0.h)
                    : InkWell(
                        onTap: () async {
                          if (Platform.isAndroid) {
                            var uri = Uri.parse(
                                "google.navigation:q=${places!.addresses[index].lat},${places!.addresses[index].lang}&mode=d");
                            launchUrl(uri);
                          } else {
                            final urlAppleMaps = Uri.parse(
                                'https://maps.apple.com/?q=${places!.addresses[index].lat},${places!.addresses[index].lang}');
                            var uri = Uri.parse(
                                'comgooglemaps://?saddr=&daddr=${places!.addresses[index].lat},${places!.addresses[index].lang}&directionsmode=driving');
                            // launchUrl(uri);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            } else if (await canLaunchUrl(urlAppleMaps)) {
                              await launchUrl(urlAppleMaps);
                            } else {
                              throw 'Could not launch $uri';
                            }
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_on_outlined),
                            SizedBox(width: 3.w),
                            Flexible(
                              flex: 2,
                              child: Text(
                                '${places!.addresses[index].branch.isNotEmpty ? ' ${places!.addresses[index].branch}: ' : ''} ${places!.addresses[index].address}',
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              (places!.addresses[index].phone.isEmpty)
                  ? SizedBox(height: 0.h)
                  : ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 120),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8)),
                        onPressed: () async {
                          await FlutterPhoneDirectCaller.callNumber(
                            places!.addresses[index].phone,
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              isRTL
                                  ? convertDigitsToFarsi(
                                      places!.addresses[index].phone)
                                  : places!.addresses[index].phone,
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            const Icon(
                              Icons.phone_android_sharp,
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}
