import 'package:flutter/material.dart';

class ShowProfilePage extends StatefulWidget {
  final String imageUrl;
  const ShowProfilePage({super.key, required this.imageUrl});

  @override
  State<ShowProfilePage> createState() => _ShowProfilePageState();
}

class _ShowProfilePageState extends State<ShowProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            Hero(tag: 'avatarHeroTag', child: Image.network(widget.imageUrl)),
      ),
    );
  }
}
