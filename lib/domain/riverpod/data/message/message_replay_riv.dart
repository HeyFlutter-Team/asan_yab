import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageBubbleAnimationNotifier extends ChangeNotifier {
  late AnimationController controller;
  late Animation<double> animation;
  double dragStartX = 0.0;
  double dragEndX = 0.0;

  MessageBubbleAnimationNotifier(TickerProvider vsync) {
    controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );
    animation = Tween<double>(begin: 0.0, end: 30.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
      ),
    )..addListener(() {
      notifyListeners();
    });
  }

  void startAnimation() {
    if (controller.isAnimating) {
      controller.stop();
    }
    controller.forward(from: 0.0);
  }

  void onHorizontalDragStart(DragStartDetails details) {
    dragStartX = details.globalPosition.dx;
  }

  void onHorizontalDragUpdate(DragUpdateDetails details, BuildContext context) {
    double dx = details.globalPosition.dx;
    if (dx < dragStartX) {
      dragEndX = dx;
      if (MediaQuery.of(context).size.width != 0) {
        controller.value = (dragEndX - dragStartX).abs() / MediaQuery.of(context).size.width;
      }
      notifyListeners();
    }
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    double distance = dragEndX - dragStartX;
    if (distance.abs() > 50) {
      startAnimation();
    } else {
      controller.reset();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

final messageBubbleAnimationProvider = ChangeNotifierProvider<MessageBubbleAnimationNotifier>((ref) =>
    MessageBubbleAnimationNotifier(ref as TickerProvider));
