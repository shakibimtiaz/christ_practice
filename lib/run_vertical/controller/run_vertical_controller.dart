import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RunVerticalController extends GetxController with GetTickerProviderStateMixin {
  late ScrollController scrollController;
  late AnimationController animationController;

  final double imageHeight = 1000; // Height of the image
  final double viewportHeight = 300; // Height of visible container
  double maxScrollExtent = 0;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    animationController.addListener(() {
      if (scrollController.hasClients) {
        final value = (1 - animationController.value) * maxScrollExtent;
    scrollController.jumpTo(value);
      }
    });

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reset();
        animationController.forward(); // Continue from current position
      }
    });
  }

  void startAnimation() {
  maxScrollExtent = imageHeight - viewportHeight;
  if (maxScrollExtent <= 0) return;

  scrollController.jumpTo(maxScrollExtent); // Start from bottom
  animationController.forward();
}


  void stopAnimation() {
    animationController.stop();
  }

  @override
  void onClose() {
    scrollController.dispose();
    animationController.dispose();
    super.onClose();
  }
}
