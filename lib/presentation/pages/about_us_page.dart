import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/res/image_res.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final languageText=AppLocalizations.of(context);
    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title:  Text(
          languageText!.about_us_page_appbar_title,
          // style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Image.asset(
                              ImageRes.heyFlutter,
                              fit: BoxFit.cover,
                              width: screenWidth * 0.31,
                              height: screenHeight * 0.15,
                            ),
                            const SizedBox(height: 16),
                            Link(
                              uri: Uri.parse('https://heyflutter.com'),
                              builder: (context, followLink) {
                                return GestureDetector(
                                  onTap: followLink,
                                  child: const Text(
                                    'HeyFlutter.com',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 16),
                          RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: 'HeyFlutter.com',
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      launchUrl(
                                          Uri.parse('https://heyflutter.com'));
                                    }),
                              TextSpan(
                                text:
                                    ' helps you to learn Flutter, Dart, Firebase and App development in one place for all platforms Android, iOS, Web and Desktop. On ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                                  // color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                  text: 'HeyFlutter.com',
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      launchUrl(
                                          Uri.parse('https://heyflutter.com'));
                                    }),
                              TextSpan(
                                text:
                                    ' website you can explore our 12 weeks Flutter Training that includes many Flutter Courses that help you to learn Flutter efficiently based on your current Flutter skill level from Newbie until Advanced level. This is just the future of learning Flutter! ⚡⚡',
                                style: TextStyle(
                                  // color: Colors.black,
                                  fontSize: 16,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                            ]),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _BuildLinkWidget(
                        url: 'https://heyflutter.com',
                        image: ImageRes.worldWideWeb,
                        name: '12-WEEK Flutter Training',
                      ),
                      _BuildLinkWidget(
                        url: 'https://www.youtube.com/@HeyFlutter',
                        image: ImageRes.youtube,
                        name: 'Follow YouTube',
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(color: Colors.black54),
                              text: 'This app organized by ',
                              children: [
                                TextSpan(
                                    text: 'HeyFlutter.com',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launchUrl(Uri.parse(
                                            'https://heyflutter.com'));
                                      }),
                                const TextSpan(
                                    text: ' team',
                                    style: TextStyle(color: Colors.black54)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuildLinkWidget extends StatelessWidget {
  final String url;
  final String image;
  final String name;

  const _BuildLinkWidget({
    required this.url,
    required this.image,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Link(
          target: LinkTarget.blank,
          uri: Uri.parse(url),
          builder: (context, followLink) => Row(
            children: [
              Image.asset(
                image,
                fit: BoxFit.cover,
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 5),
              TextButton(
                onPressed: followLink,
                child: Text(
                  name,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}
