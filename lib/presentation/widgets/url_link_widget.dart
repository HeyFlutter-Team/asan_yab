import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/link.dart';

class UrlLinkWidget extends StatelessWidget {
  final String url;
  final String image;
  final String name;

  const UrlLinkWidget({
    super.key,
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
              SizedBox(width: 5.w),
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
        SizedBox(height: 4.h),
      ],
    );
  }
}
