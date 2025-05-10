import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class UpdateRunController extends GetxController with GetTickerProviderStateMixin {
  late ScrollController scrollController;
  late AnimationController animationController;

  final double imageWidth = 1000;
  final double viewportWidth = 400;
  double maxScrollExtent = 0;

  late final Animation<double> animation;

  var isRunning = false.obs;
  var isPaused = false.obs;
  var distance = 0.0.obs;
  var elapsedTime = '00:00:00'.obs;
  var elevationGain = 0.0.obs;
  var isClimbing = false.obs;

  var lastPosition = Rxn<Position>();
  Timer? _timer;
  int _seconds = 0;
  StreamSubscription<Position>? _positionSubscription;

  @override
  void onInit() {
    super.onInit();
    _requestLocationPermission();
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
    _timer?.cancel();
    _positionSubscription?.cancel();
    super.onClose();
  }

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Error', 'Location services are disabled.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Error', 'Location permission denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Error', 'Location permission permanently denied.');
      return;
    }
  }

  void startRun() async {
    if (!isRunning.value) {
      isRunning.value = true;
      lastPosition.value = await Geolocator.getCurrentPosition();
      _startTimer();
      _startLocationTracking();
      startAnimation();
    } else if (isPaused.value) {
      isPaused.value = false;
      lastPosition.value = await Geolocator.getCurrentPosition();
      _startTimer();
      _startLocationTracking();
      startAnimation();
    }
  }

  void pauseRun() {
    isPaused.value = true;
    _timer?.cancel();
    _positionSubscription?.cancel();
    stopAnimation();
  }

  void stopRun() {
    isRunning.value = false;
    isPaused.value = false;
    distance.value = 0.0;
    elevationGain.value = 0.0;
    isClimbing.value = false;
    lastPosition.value = null;
    _timer?.cancel();
    _positionSubscription?.cancel();
    stopAnimation();
    resetTracking();
  }

  void resetTracking() {
    isPaused.value = false;
    elapsedTime.value = '00:00:00';
    distance.value = 0.0;
    elevationGain.value = 0.0;
    _seconds = 0;
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _seconds++;
      int hours = _seconds ~/ 3600;
      int minutes = (_seconds % 3600) ~/ 60;
      int seconds = _seconds % 60;
      elapsedTime.value =
          '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    });
  }

  void _startLocationTracking() {
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5,
      ),
    ).listen((Position position) {
      if (lastPosition.value != null && !isPaused.value && isRunning.value) {
        // Calculate distance
        double distanceInMeters = Geolocator.distanceBetween(
          lastPosition.value!.latitude,
          lastPosition.value!.longitude,
          position.latitude,
          position.longitude,
        );
        distance.value += distanceInMeters;

        // Calculate elevation gain
        double lastAltitude = lastPosition.value!.altitude;
        double newAltitude = position.altitude;
        double gain = newAltitude - lastAltitude;
        if (gain > 0) {
          elevationGain.value += gain;
          isClimbing.value = true;
        } else {
          isClimbing.value = false;
        }
      }
      lastPosition.value = position;
    });
  }
}
