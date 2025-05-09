import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/run_tracker_controller.dart';

class RunTrackerScreen extends StatelessWidget {
  RunTrackerScreen({super.key});

  // Ensure the controller is properly instantiated
  final RunTrackerController controller = Get.put(RunTrackerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: controller.viewportHeight,
                width: controller.viewportWidth,
                child: AnimatedBuilder(
                  animation: controller.animationController,
                  builder: (_, __) {
                    return controller.isVertical
                        ? SingleChildScrollView(
                            controller: controller.verticalScrollController,
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            child: Image.asset(
                              'assets/upCover.png',
                              height: controller.imageHeight,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(color: Colors.grey); // Fallback for missing image
                              },
                            ),
                          )
                        : SingleChildScrollView(
                            controller: controller.horizontalScrollController,
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            child: Image.asset(
                              'assets/runCover.png',
                              width: controller.imageWidth,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(color: Colors.grey); // Fallback for missing image
                              },
                            ),
                          );
                  },
                ),
              ),
              Positioned(
                top: 120,
                left: controller.viewportWidth / 2 - 20,
                child:  Image.asset(
                      controller.isVertical ? 'assets/listCharacterGirl.png' : 'assets/girlCharacter.png',
                      width: 40,
                      height: 40,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(); // Fallback for missing character image
                      },
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Use individual Obx for each observable Text widget
          Obx(() => Text("Distance: ${controller.totalDistance.value.toStringAsFixed(2)} m")),
          Obx(() => Text("Climbed: ${controller.totalClimbed.value.toStringAsFixed(2)} m")),
          Obx(() => Text(
              "Time: ${controller.elapsedTime.value.inMinutes}:${(controller.elapsedTime.value.inSeconds % 60).toString().padLeft(2, '0')}")),
          const SizedBox(height: 20),
          Obx(() => controller.isRunning.value
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: controller.isPaused.value ? controller.resumeRun : controller.pauseRun,
                      child: Text(controller.isPaused.value ? 'Resume' : 'Pause'),
                    ),
                    ElevatedButton(
                      onPressed: controller.stopRun,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Stop'),
                    ),
                  ],
                )
              : ElevatedButton(
                  onPressed: controller.startRun,
                  child: const Text('Start'),
                )),
        ],
      ),
    );
  }
}