// ignore_for_file: constant_identifier_names

library circular_countdown_timer;

import 'package:flutter/material.dart';
import 'custom_timer_painter.dart';

/// Create a Circular Countdown Timer.
class CircularCountDownTimer extends StatefulWidget {
  /// Filling Color for Countdown Widget.
  final Color fillColor;

  /// Filling Gradient for Countdown Widget.
  final Gradient? fillGradient;

  /// Ring Color for Countdown Widget.
  final Color ringColor;

  /// Ring Gradient for Countdown Widget.
  final Gradient? ringGradient;

  /// Background Color for Countdown Widget.
  final Color? backgroundColor;

  /// Background Gradient for Countdown Widget.
  final Gradient? backgroundGradient;

  /// This Callback will execute when the Countdown Ends.
  final VoidCallback? onComplete;

  /// This Callback will execute when the Countdown Starts.
  final VoidCallback? onStart;

  /// This Callback will execute when the Countdown Changes.
  final ValueChanged<String>? onChange;

  /// Countdown duration in Seconds.
  final int duration;

  /// Countdown initial elapsed Duration in Seconds.
  final int initialDuration;

  /// Width of the Countdown Widget.
  final double width;

  /// Height of the Countdown Widget.
  final double height;

  /// Border Thickness of the Countdown Ring.
  final double strokeWidth;

  /// Begin and end contours with a flat edge and no extension.
  final StrokeCap strokeCap;

  /// Text Style for Countdown Text.
  final TextStyle? textStyle;

  /// Format for the Countdown Text.
  final String? textFormat;

  /// Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
  final bool isReverse;

  /// Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
  final bool isReverseAnimation;

  /// Handles visibility of the Countdown Text.
  final bool isTimerTextShown;

  /// Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
  final CountDownController? controller;

  /// Handles the timer start.
  final bool autoStart;

  /// background image for Countdown Widget.
  final String? backgroundImage;

  const CircularCountDownTimer({
    required this.width,
    required this.height,
    required this.duration,
    required this.fillColor,
    required this.ringColor,
    this.backgroundImage,
    this.backgroundColor,
    this.fillGradient,
    this.ringGradient,
    this.backgroundGradient,
    this.initialDuration = 0,
    this.isReverse = false,
    this.isReverseAnimation = false,
    this.onComplete,
    this.onStart,
    this.onChange,
    this.strokeWidth = 5.0,
    this.strokeCap = StrokeCap.butt,
    this.textStyle,
    super.key,
    this.isTimerTextShown = true,
    this.autoStart = true,
    this.textFormat,
    this.controller,
  }) : assert(initialDuration <= duration);

  @override
  CircularCountDownTimerState createState() => CircularCountDownTimerState();
}

class CircularCountDownTimerState extends State<CircularCountDownTimer>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _countDownAnimation;
  CountDownController? countDownController;

  String get time {
    String timeStamp = "";
    if (widget.isReverse &&
        !widget.autoStart &&
        !countDownController!.isStarted) {
      timeStamp = _getTime(Duration(seconds: widget.duration));
    } else {
      Duration? duration = _controller!.duration! * _controller!.value;
      timeStamp = _getTime(duration);
    }
    if (widget.onChange != null) widget.onChange!(timeStamp);

    return timeStamp;
  }

  void _setAnimation() {
    if (widget.autoStart) {
      if (widget.isReverse) {
        _controller!.reverse(from: 1);
      } else {
        _controller!.forward();
      }
    }
  }

  void _setAnimationDirection() {
    // if ((widget.isReverse && !widget.isReverseAnimation) ||
    //     (widget.isReverse && widget.isReverseAnimation)) {
    //   _countDownAnimation =
    //       Tween<double>(begin: 1, end: 0).animate(_controller!);
    // } else if (!widget.isReverse && widget.isReverseAnimation) {
    //   _countDownAnimation =
    //       Tween<double>(begin: 0, end: 1).animate(_controller!);
    // }
    if ((!widget.isReverse && widget.isReverseAnimation) ||
        (widget.isReverse && !widget.isReverseAnimation)) {
      _countDownAnimation =
          Tween<double>(begin: 1, end: 0).animate(_controller!);
    }
  }

  void _setController() {
    countDownController?._state = this;
    countDownController?._isReverse = widget.isReverse;
    countDownController?._initialDuration = widget.initialDuration;
    countDownController?._duration = widget.duration;
    countDownController?.isStarted = widget.autoStart;

    if (widget.initialDuration > 0 && widget.autoStart) {
      if (widget.isReverse) {
        _controller?.value = 1 - (widget.initialDuration / widget.duration);
      } else {
        _controller?.value = (widget.initialDuration / widget.duration);
      }

      countDownController?.start();
    }
  }

  String _getTime(Duration duration) {
    // For HH:mm:ss format
    if (widget.textFormat == CountdownTextFormat.HH_MM_SS) {
      return '${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    // For mm:ss format
    else if (widget.textFormat == CountdownTextFormat.MM_SS) {
      return '${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    // For ss format
    else if (widget.textFormat == CountdownTextFormat.SS) {
      return (duration.inSeconds).toString().padLeft(2, '0');
    }
    // For s format
    else if (widget.textFormat == CountdownTextFormat.S) {
      return '${(duration.inSeconds)}';
    } else {
      // Default format
      return _defaultFormat(duration);
    }
  }

  _defaultFormat(Duration duration) {
    if (duration.inHours != 0) {
      return '${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    } else if (duration.inMinutes != 0) {
      return '${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    } else {
      return '${duration.inSeconds % 60}';
    }
  }

  void _onStart() {
    if (widget.onStart != null) widget.onStart!();
  }

  void _onComplete() {
    if (widget.onComplete != null) widget.onComplete!();
  }

  @override
  void initState() {
    countDownController = widget.controller ?? CountDownController();
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    );

    _controller!.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.forward:
          _onStart();
          break;

        case AnimationStatus.reverse:
          _onStart();
          break;

        case AnimationStatus.dismissed:
          _onComplete();
          break;
        case AnimationStatus.completed:

          /// [AnimationController]'s value is manually set to [1.0] that's why [AnimationStatus.completed] is invoked here this animation is [isReverse]
          /// Only call the [_onComplete] block when the animation is not reversed.
          if (!widget.isReverse) _onComplete();
          break;
        default:
        // Do nothing
      }
    });

    _setAnimation();
    _setAnimationDirection();
    _setController();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
          animation: _controller!,
          builder: (context, child) {
            return Align(
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Stack(
                  children: <Widget>[
                    if (widget.backgroundImage != null)
                      Positioned.fill(
                        child: Image.asset(
                          widget.backgroundImage!,
                          fit: BoxFit.fill,
                        ),
                      ),
                    Positioned.fill(
                      child: CustomPaint(
                        painter: CustomTimerPainter(
                            animation: _countDownAnimation ?? _controller,
                            fillColor: widget.fillColor,
                            fillGradient: widget.fillGradient,
                            ringColor: widget.ringColor,
                            ringGradient: widget.ringGradient,
                            strokeWidth: widget.strokeWidth,
                            strokeCap: widget.strokeCap,
                            isReverse: widget.isReverse,
                            isReverseAnimation: widget.isReverseAnimation,
                            backgroundColor: widget.backgroundColor,
                            backgroundImage: widget.backgroundImage,
                            backgroundGradient: widget.backgroundGradient),
                      ),
                    ),
                    widget.isTimerTextShown
                        ? Align(
                            alignment: FractionalOffset.center,
                            child: Text(
                              time,
                              style: widget.textStyle ??
                                  const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            );
          }),
    );
  }

  @override
  void dispose() {
    _controller!.stop();
    _controller!.dispose();
    super.dispose();
  }
}

/// Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
class CountDownController {
  CircularCountDownTimerState? _state;
  bool? _isReverse;
  bool isStarted = false, isPaused = false, isResumed = false;
  int? _initialDuration, _duration;

  /// This Method Starts the Countdown Timer
  void start() {
    if (_isReverse != null && _state != null && _state?._controller != null) {
      if (_isReverse!) {
        _state?._controller?.reverse(
            from: _initialDuration == 0
                ? 1
                : 1 - (_initialDuration! / _duration!));
      } else {
        _state?._controller?.forward(
            from: _initialDuration == 0 ? 0 : (_initialDuration! / _duration!));
      }
      isStarted = true;
    }
  }

  /// This Method Pauses the Countdown Timer
  void pause() {
    if (_state != null && _state?._controller != null) {
      _state?._controller?.stop(canceled: false);
      isPaused = true;
      isResumed = false;
    }
  }

  /// This Method Resumes the Countdown Timer
  void resume() {
    if (_isReverse != null && _state != null && _state?._controller != null) {
      if (_isReverse!) {
        _state?._controller?.reverse(from: _state!._controller!.value);
      } else {
        _state?._controller?.forward(from: _state!._controller!.value);
      }
      isResumed = true;
      isPaused = false;
    }
  }

  /// This Method Restarts the Countdown Timer,
  /// Here optional int parameter **duration** is the updated duration for countdown timer

  void restart({int? duration}) {
    if (_isReverse != null && _state != null && _state?._controller != null) {
      _state?._controller!.duration = Duration(
          seconds: duration ?? _state!._controller!.duration!.inSeconds);
      if (_isReverse!) {
        _state?._controller?.reverse(from: 1);
      } else {
        _state?._controller?.forward(from: 0);
      }
      isStarted = true;
      isPaused = false;
      isResumed = false;
    }
  }

  /// This Method resets the Countdown Timer
  void reset() {
    if (_state != null && _state?._controller != null) {
      _state?._controller?.reset();
      isStarted = _state?.widget.autoStart ?? false;
      isPaused = false;
      isResumed = false;
    }
  }

  /// This Method returns the **Current Time** of Countdown Timer i.e
  /// Time Used in terms of **Forward Countdown** and Time Left in terms of **Reverse Countdown**

  String? getTime() {
    if (_state != null && _state?._controller != null) {
      return _state?._getTime(
          _state!._controller!.duration! * _state!._controller!.value);
    }
    return "";
  }
}

class CountdownTextFormat {
  static const String HH_MM_SS = "HH:mm:ss";
  static const String MM_SS = "mm:ss";
  static const String SS = "ss";
  static const String S = "s";
}
