import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import '../constants/kcolors.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text(
          ' در باره ما',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: kPrimaryColor,
        elevation: 0,
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
                              'assets/hey_flutter.png',
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
                              const TextSpan(
                                text:
                                    ' helps you to learn Flutter, Dart, Firebase and App development in one place for all platforms Android, iOS, Web and Desktop. On ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
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
                              const TextSpan(
                                text:
                                    ' website you can explore our 12 weeks Flutter Training that includes many Flutter Courses that help you to learn Flutter efficiently based on your current Flutter skill level from Newbie until Advanced level. This is just the future of learning Flutter! ⚡⚡',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ]),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const _BuildLinkWidget(
                        url: 'https://heyflutter.com',
                        image: 'assets/world-wide-web.png',
                        name: '12-WEEK Flutter Training',
                      ),
                      const _BuildLinkWidget(
                        url: 'https://www.youtube.com/@HeyFlutter',
                        image: 'assets/youtube.png',
                        name: 'Follow YouTube',
                      ),
                      const _BuildLinkWidget(
                        url: 'https://www.instagram.com/heyflutter',
                        image: 'assets/instagram.png',
                        name: 'Follow Instagram',
                      ),
                      const _BuildLinkWidget(
                        url: 'https://twitter.com/HeyFlutter',
                        image: 'assets/twitter.png',
                        name: 'Follow Twitter',
                      ),
                      const _BuildLinkWidget(
                        url: 'https://github.com/JohannesMilke',
                        image: 'assets/code.png',
                        name: 'Follow GitHub',
                      ),
                      const _BuildLinkWidget(
                        url: 'https://www.linkedin.com/company/heyflutter',
                        image: 'assets/linkedin.png',
                        name: 'Follow Linkedin',
                      ),
                      const _BuildLinkWidget(
                        url: 'https://www.facebook.com/heyflutter',
                        image: 'assets/facebook.png',
                        name: 'Follow Facebook',
                      ),
                      const _BuildLinkWidget(
                        url: 'https://www.tiktok.com/@heyflutter.com',
                        image: 'assets/tiktok.png',
                        name: 'Follow TikTok',
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
