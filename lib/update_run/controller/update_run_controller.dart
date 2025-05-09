import 'package:get/get.dart';
import 'package:flutter/material.dart';


class UpdateRunController extends GetxController with GetTickerProviderStateMixin {
  late ScrollController scrollController;
  late AnimationController animationController;

  final double imageWidth = 1000;  
  final double viewportWidth = 400;  
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
        final value = animationController.value * maxScrollExtent;
        scrollController.jumpTo(value);
      }
    });

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reset();
        animationController.forward();  
      }
    });
  }

  void startAnimation() {
    // Calculate max scrollable distance only once
    maxScrollExtent = imageWidth - viewportWidth;
    if (maxScrollExtent <= 0) return;
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