// ignore: file_names
import 'package:christ_practice/updated_run_vertical/controller/updated_run_vertical_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatedRunVerticalScreen extends StatelessWidget {
   UpdatedRunVerticalScreen({super.key});
   

  final UpdatedRunVerticalController controller =  Get.put(UpdatedRunVerticalController()); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: 300,
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
                            width: double.infinity,
                            height: controller.imageHeight,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 120,
                left: MediaQuery.of(context).size.width / 2 - 50,
                child: Image.asset(
                  "assets/listCharacterGirl.png", 
                  width: 100, 
                  height: 100,
                ),
                
              )
            ],
          ), 
          

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: controller.startAnimation,
                  child: const Text('Start'),
                ),

              ElevatedButton(
                  onPressed: controller.stopAnimation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Stop'),
                ),  
            ],
          )

        ],
      ),
    );
  }
}