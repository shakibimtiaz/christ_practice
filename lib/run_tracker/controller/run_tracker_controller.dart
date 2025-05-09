import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class RunTrackerController extends GetxController with GetTickerProviderStateMixin {
  late ScrollController horizontalScrollController;
  late ScrollController verticalScrollController;
  late AnimationController animationController;

  final double imageWidth = 1000;
  final double imageHeight = 1000;
  final double viewportWidth = 400;
  final double viewportHeight = 300;

  double maxHorizontalScroll = 0;
  double maxVerticalScroll = 0;

  var isRunning = false.obs;
  var isPaused = false.obs;
  var totalDistance = 0.0.obs;
  var totalClimbed = 0.0.obs;
  var elapsedTime = Duration.zero.obs;

  Position? lastPosition;
  Timer? timer;
  Timer? checkMovementTimer;
  double lastCheckedDistance = 0.0;

  StreamSubscription<Position>? positionStream;
  var _isVertical = false;
  bool get isVertical => _isVertical;

  @override
  void onInit() {
    super.onInit();
    horizontalScrollController = ScrollController();
    verticalScrollController = ScrollController();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        if (!horizontalScrollController.hasClients || !verticalScrollController.hasClients) return;

        double value = animationController.value;
        if (_isVertical) {
          verticalScrollController.jumpTo((1 - value) * maxVerticalScroll);
        } else {
          horizontalScrollController.jumpTo(value * maxHorizontalScroll);
        }
      });

    maxHorizontalScroll = imageWidth - viewportWidth;
    maxVerticalScroll = imageHeight - viewportHeight;
  }

  void startRun() async {
    isRunning.value = true;
    isPaused.value = false;
    totalDistance.value = 0;
    totalClimbed.value = 0;
    elapsedTime.value = Duration.zero;
    lastCheckedDistance = 0;
    lastPosition = null;

    // Timer to track elapsed time
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isPaused.value) {
        elapsedTime.value += const Duration(seconds: 1);
      }
    });

    // Timer to check distance every 5 seconds
    checkMovementTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!isPaused.value && isRunning.value) {
        double currentDistance = totalDistance.value;
        if (currentDistance != lastCheckedDistance) {
          // Distance changed, start/resume animation
          animationController.repeat();
        } else {
          // No movement, stop animation
          animationController.stop();
        }
        lastCheckedDistance = currentDistance;
      }
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return;
    }

    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 1),
    ).listen((Position position) {
      if (lastPosition != null && !isPaused.value) {
        double distance = Geolocator.distanceBetween(
          lastPosition!.latitude,
          lastPosition!.longitude,
          position.latitude,
          position.longitude,
        );

        double climb = position.altitude - lastPosition!.altitude;
        if (climb > 0) totalClimbed.value += climb;
        totalDistance.value += distance;

        _isVertical = (climb.abs() > distance.abs());
      }
      lastPosition = position;
    });
  }

  void pauseRun() {
    isPaused.value = true;
    animationController.stop();
  }

  void resumeRun() {
    isPaused.value = false;
    animationController.repeat();
  }

  void stopRun() {
    timer?.cancel();
    checkMovementTimer?.cancel();
    positionStream?.cancel();
    animationController.stop();

    Get.defaultDialog(
      title: "Run Summary",
      content: Column(
        children: [
          Text("Total Distance: ${totalDistance.value.toStringAsFixed(2)} meters"),
          Text("Total Climbed: ${totalClimbed.value.toStringAsFixed(2)} meters"),
          Text("Time Taken: ${elapsedTime.value.inMinutes}:${(elapsedTime.value.inSeconds % 60).toString().padLeft(2, '0')}")
        ],
      ),
      confirm: ElevatedButton(
        onPressed: () {
          isRunning.value = false;
          isPaused.value = false;
          totalDistance.value = 0;
          totalClimbed.value = 0;
          elapsedTime.value = Duration.zero;
          Get.back();
        },
        child: const Text("OK"),
      ),
    );
  }

  @override
  void onClose() {
    horizontalScrollController.dispose();
    verticalScrollController.dispose();
    animationController.dispose();
    timer?.cancel();
    checkMovementTimer?.cancel();
    positionStream?.cancel();
    super.onClose();
  }
}
