library circular_countdown_timer;

import 'package:circular_countdown_timer/functions/helper_functions.dart';
import 'package:flutter/material.dart';

import 'custom_timer_painter.dart';
import 'countdown_controller.dart';

export 'countdown_text_format.dart';
export 'countdown_controller.dart';

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

  /// Countdown initial elapsed Duration in Seconds.
  final Duration initialDuration;

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

  /// Text Align for Countdown Text.
  final TextAlign textAlign;

  /// Format for the Countdown Text.
  final String? textFormat;

  /// Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
  final bool isReverse;

  /// Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
  final bool isReverseAnimation;

  /// Handles visibility of the Countdown Text.
  final bool isTimerTextShown;

  /// Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
  final CountDownController countdownController;

  /// Handles the timer start.
  final Function timeFormatterFunction;
  /* 
   * Function to format the text.
   * Allows you to format the current duration to any String.
   * It also provides the default function in case you want to format specific moments
     as in reverse when reaching '0' show 'GO', and for the rest of the instances follow 
     the default behavior.
  */
  static emptyCallback(Function(Duration duration, String? textFormat) defaultFormatterFunction, Duration duration, String? textFormat){}


  const CircularCountDownTimer({
    required this.width,
    required this.height,
    required this.fillColor,
    required this.ringColor,
    this.timeFormatterFunction = emptyCallback,
    this.backgroundColor,
    this.fillGradient,
    this.ringGradient,
    this.backgroundGradient,
    this.initialDuration = const Duration(seconds: 10),
    this.isReverse = false,
    this.isReverseAnimation = false,
    this.onComplete,
    this.onStart,
    this.onChange,
    this.strokeWidth = 5.0,
    this.strokeCap = StrokeCap.butt,
    this.textStyle,
    this.textAlign = TextAlign.left,
    super.key,
    this.isTimerTextShown = true,
    this.textFormat,
    required this.countdownController,
  });

  @override
  CircularCountDownTimerState createState() => CircularCountDownTimerState();
}

class CircularCountDownTimerState extends State<CircularCountDownTimer>
    with TickerProviderStateMixin {
  AnimationController? _animationController;

  String get time {
    if (widget.isReverse &&
        !widget.countdownController.autoStart &&
        !widget.countdownController.autoStart &&
        !widget.countdownController.isStarted) {
      return Function.apply(widget.timeFormatterFunction, [HelperFunctions.getTimeFormatted, widget.countdownController.duration, widget.textFormat]).toString();
    } else {
      Duration duration =
          _animationController!.duration! * _animationController!.value;
      return Function.apply(widget.timeFormatterFunction, [HelperFunctions.getTimeFormatted, duration, widget.textFormat]).toString();

    }
  }

  void _setAnimation() {
    if (widget.countdownController.autoStart) {
      if (widget.isReverse) {
        _animationController!.reverse(from: 1);
      } else {
        _animationController!.forward();
      }
    }
  }

  void _setAnimationDirection() {
    if ((!widget.isReverse && widget.isReverseAnimation) ||
        (widget.isReverse && !widget.isReverseAnimation)) {
    }
  }

  void _setController() {
    widget.countdownController.animationController = _animationController;
    widget.countdownController.isReverse = widget.isReverse;
    widget.countdownController.initialDuration = widget.initialDuration;
    widget.countdownController.textFormat = widget.textFormat;

    if (widget.initialDuration.inSeconds > 0 && widget.countdownController.autoStart) {
      if (widget.isReverse) {
        _animationController?.value =
            1 - (widget.initialDuration.inSeconds / widget.countdownController.duration.inSeconds);
      } else {
        _animationController?.value =
            (widget.initialDuration.inSeconds / widget.countdownController.duration.inSeconds);
      }

      widget.countdownController.start();
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
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.countdownController.duration,
    );

    _animationController!.addStatusListener((status) {
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
          animation: _animationController!,
          builder: (context, child) {
            return Align(
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: CustomTimerPainter(
                            animation:
                                _animationController,
                            fillColor: widget.fillColor,
                            fillGradient: widget.fillGradient,
                            ringColor: widget.ringColor,
                            ringGradient: widget.ringGradient,
                            strokeWidth: widget.strokeWidth,
                            strokeCap: widget.strokeCap,
                            isReverse: widget.isReverse,
                            isReverseAnimation: widget.isReverseAnimation,
                            backgroundColor: widget.backgroundColor,
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
                              textAlign: widget.textAlign,
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
    _animationController!.stop();
    _animationController!.dispose();
    super.dispose();
  }
}
