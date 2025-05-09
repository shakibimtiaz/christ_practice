
import 'package:christ_practice/run_vertical/controller/run_vertical_controller.dart' show RunVerticalController;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RunVerticalScreen extends StatelessWidget {
  RunVerticalScreen({super.key});

  final RunVerticalController controller = Get.put(RunVerticalController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Vertical scrolling image
          Container(
            height: controller.viewportHeight,
            width: double.infinity,
            color: Colors.black12,
            child: AnimatedBuilder(
              animation: controller.animationController,
              builder: (context, child) {
                return SingleChildScrollView(
                  controller: controller.scrollController,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/upCover.png',
                        height: controller.imageHeight,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Static center image
          Positioned(
            child: Image.asset(
              'assets/listCharacterGirl.png',
              height: 100,
              width: 100,
            ),
          ),

          // Start & Stop buttons
          Positioned(
            bottom: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: controller.startAnimation,
                  child: const Text('Start'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: controller.stopAnimation,
                  child: const Text('Stop'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
