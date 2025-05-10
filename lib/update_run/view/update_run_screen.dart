import 'package:christ_practice/update_run/controller/update_run_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateRunScreen extends StatelessWidget {
   UpdateRunScreen({super.key});

  final UpdateRunController controller = Get.put(UpdateRunController()); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              AnimatedBuilder(
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
              Positioned(
                left: MediaQuery.of(context).size.width / 2 - 20,
                top: 120,
                child: Image.asset(
                  'assets/girlCharacter.png', 
                  height: 40, 
                  width: 40,
                ),
                
              )
            ],
          ),

          SizedBox(
            height: 20,
          ), 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
               Obx(
              () => Text(
                'Time: ${controller.elapsedTime.value}',
                style: const TextStyle(fontSize: 24),
              ),
            ),
              Obx(
              () => Text(
                'Distance: ${controller.distance.value.toStringAsFixed(0)} m',
                style: const TextStyle(fontSize: 24),
              ),
            ),
            ],
          ), 
          Row(
            mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: controller.startRun,
                  child: const Text('Start'),
                ),
              ElevatedButton(
                  onPressed: controller.stopRun,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child:  Text('Stop'),
                ),  
            ],
          )
        ],
      ),
    );
  }
}