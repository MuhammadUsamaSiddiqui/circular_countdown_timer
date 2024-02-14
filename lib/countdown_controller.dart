import 'package:flutter/material.dart';
import 'functions/helper_functions.dart';

/// Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
class CountDownController {
  AnimationController? animationController;
  ValueNotifier<bool> isReverse;
  ValueNotifier<bool>  isReverseAnimation;
  ValueNotifier<bool> isStarted = ValueNotifier<bool>(false);
  ValueNotifier<bool> isPaused = ValueNotifier<bool>(false);
  ValueNotifier<bool> isResumed = ValueNotifier<bool>(false);
  ValueNotifier<bool> isRestarted = ValueNotifier<bool>(false);
  Duration initialDuration;
  Duration duration;
  String? textFormat;
  ValueNotifier<bool> autoStart = ValueNotifier<bool>(false);
  Function onStartCallback;
  Function onCompleteCallback;

  static emptyCallback() {}

  CountDownController(
      {required this.duration,
      required this.initialDuration,
      required this.autoStart,
      required this.isReverse,
      required this.isReverseAnimation,
      this.onStartCallback = emptyCallback,
      this.onCompleteCallback = emptyCallback});

  /// This Method Starts the Countdown Timer
  void start() {

    if (animationController != null) {
      if (isReverse.value) {
        animationController?.reverse(from: 1);
      } else {
        animationController?.forward(from: 0);
      }
      isStarted.value = true;
      isRestarted.value = false;
      isPaused.value = false;
      isResumed.value = false;
    }
  }

  /// This Method Pauses the Countdown Timer
  void pause() {
    if (animationController != null) {
      animationController?.stop(canceled: false);
      isPaused.value = true;
      isRestarted.value = false;
      isResumed.value = false;
    }
  }

  /// This Method Resumes the Countdown Timer
  void resume() {
    if (animationController != null) {
      if (isReverse.value) {
        animationController?.reverse(from: animationController!.value);
      } else {
        animationController?.forward(from: animationController!.value);
      }
      isResumed.value = true;
      isRestarted.value = false;
      isPaused.value = false;
    }
  }

  /// This Method Restarts the Countdown Timer,
  /// Here optional int parameter **duration** is the updated duration for countdown timer

  void restart({int? duration}) {
    if (animationController != null) {
      animationController!.duration = Duration(
          seconds: duration ?? animationController!.duration!.inSeconds);
      if (isReverse.value) {
        animationController?.reverse(from: 1);
      } else {
        animationController?.forward(from: 0);
      }
      isStarted.value = true;
      isRestarted.value = true;
      isPaused.value = false;
      isResumed.value = false;
    }
  }

  /// This Method resets the Countdown Timer
  void reset({int? duration}) {
    if (animationController != null) {
      this.duration = Duration(seconds: duration ?? this.duration.inSeconds);
      animationController!.duration = Duration(
          seconds: duration ?? animationController!.duration!.inSeconds);
      animationController?.reset();
      isStarted = autoStart;
      isRestarted.value = false;
      isPaused.value = false;
      isResumed.value = false;
    }
  }

  /// This Method returns the **Current Time** of Countdown Timer i.e
  /// Time Used in terms of **Forward Countdown** and Time Left in terms of **Reverse Countdown**

  String? getTime() {
    String value = "";
    if (animationController != null) {
      value = HelperFunctions.getTimeFormatted(
          animationController!.duration! * animationController!.value,
          textFormat);
    }
    return value;
  }
}
