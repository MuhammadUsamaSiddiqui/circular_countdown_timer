import 'package:flutter/animation.dart';
import 'functions/helper_functions.dart';

/// Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
class CountDownController {
  AnimationController? animationController;
  bool isReverse;
  bool isReverseAnimation;
  bool isStarted = false;
  bool isPaused = false;
  bool isResumed = false;
  bool isRestarted = false;
  Duration initialDuration;
  Duration duration;
  String? textFormat;
  bool autoStart;
  Function onStartCallback;
  Function onCompleteCallback;

  static emptyCallback() {}

  CountDownController(
      {required this.duration,
      required this.initialDuration,
      this.autoStart = false,
      this.isReverse = false,
      this.isReverseAnimation = false,
      this.onStartCallback = emptyCallback,
      this.onCompleteCallback = emptyCallback});

  /// This Method Starts the Countdown Timer
  void start() {
    /*
    if (animationController != null) {
      if (isReverse) {
        animationController?.reverse(
            from:
                initialDuration.inSeconds == 0 ? 1 : 1 - (initialDuration.inSeconds / duration.inSeconds));
      } else {
        animationController?.forward(
            from: initialDuration.inSeconds == 0 ? 0 : (initialDuration.inSeconds / duration.inSeconds));
      }
      isStarted = true;
      isPaused = false;
      isResumed = false;
      isRestarted = false;
    } */
    if (animationController != null) {
      if (isReverse) {
        animationController?.reverse(from: 1);
      } else {
        animationController?.forward(from: 0);
      }
      isStarted = true;
      isRestarted = false;
      isPaused = false;
      isResumed = false;
    }
  }

  /// This Method Pauses the Countdown Timer
  void pause() {
    if (animationController != null) {
      animationController?.stop(canceled: false);
      isPaused = true;
      isRestarted = false;
      isResumed = false;
    }
  }

  /// This Method Resumes the Countdown Timer
  void resume() {
    if (animationController != null) {
      if (isReverse) {
        animationController?.reverse(from: animationController!.value);
      } else {
        animationController?.forward(from: animationController!.value);
      }
      isResumed = true;
      isRestarted = false;
      isPaused = false;
    }
  }

  /// This Method Restarts the Countdown Timer,
  /// Here optional int parameter **duration** is the updated duration for countdown timer

  void restart({int? duration}) {
    if (animationController != null) {
      animationController!.duration = Duration(
          seconds: duration ?? animationController!.duration!.inSeconds);
      if (isReverse) {
        animationController?.reverse(from: 1);
      } else {
        animationController?.forward(from: 0);
      }
      isStarted = true;
      isRestarted = true;
      isPaused = false;
      isResumed = false;
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
      isRestarted = false;
      isPaused = false;
      isResumed = false;
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
