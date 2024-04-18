import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCardWidget extends StatelessWidget {
  const CustomCardWidget({
    super.key,
    required this.title,
    this.description,
    this.child,
  });

  final String title;
  final String? description;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity.w,
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline),
                        SizedBox(width: 12.w),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 0.5,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 4.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: child,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}
