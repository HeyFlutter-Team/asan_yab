import 'package:flutter/material.dart';

class PageViewItem extends StatelessWidget {
  final String imgUrl;

  const PageViewItem({super.key, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showBottomSheet(
          context: context,
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Image.asset(
                    imgUrl,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        backgroundColor: Colors.blueGrey,
                        minimumSize: const Size(double.maxFinite, 55)),
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_back_ios_sharp),
                        SizedBox(width: 3),
                        Text('Back')
                      ],
                    )),
              ],
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Hero(
          tag: imgUrl,
          child: Image.asset(
            imgUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
