import 'package:christ_practice/run/controller/run_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RunScreen extends StatelessWidget {
  RunScreen({super.key});

  final RunController controller = Get.put(RunController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
         
          Container(
            height: 300,
            width: double.infinity,
            color: Colors.black12,
            child: AnimatedBuilder(
              animation: controller.animationController,
              builder: (context, child) {
                return SingleChildScrollView(
                  controller: controller.scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/runCover.png',
                        width: controller.imageWidth,
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
              'assets/girlCharacter.png',
              height: 100,
              width: 100,
            ),
          ),

          

          // Buttons
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child:  Text('Stop'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
