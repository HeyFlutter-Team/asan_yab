import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/res/image_res.dart';
import '../../core/utils/translation_util.dart';
import '../widgets/url_link_widget.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final text = texts(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(text.about_us_page_appbar_title),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
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
                              builder: (context, followLink) => GestureDetector(
                                onTap: followLink,
                                child: const Text(
                                  'HeyFlutter.com',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
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
                      const UrlLinkWidget(
                        url: 'https://heyflutter.com',
                        image: ImageRes.worldWideWeb,
                        name: '12-WEEK Flutter Training',
                      ),
                      const UrlLinkWidget(
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
                              style: const TextStyle(color: Colors.black54),
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
