library circular_countdown_timer;

import 'package:flutter/material.dart';
import 'custom_timer_painter.dart';

/// Create a Circular Countdown Timer
class CircularCountDownTimer extends StatefulWidget {
  /// Filling Color for Countdown Timer
  final Color fillColor;

  /// Default Color for Countdown Timer
  final Color color;

  /// Function which will execute when the Countdown Ends
  final Function onComplete;

  /// Countdown Duration in Seconds
  final int duration;

  /// Width of the Countdown Widget
  final double width;

  /// Height of the Countdown Widget
  final double height;

  /// Border Thickness of the Countdown Circle
  final double strokeWidth;

  /// Text Style for Countdown Text
  final TextStyle textStyle;

  /// true for reverse countdown (max to 0), false for forward countdown (0 to max)
  final bool isReverse;

  /// Optional [bool] to hide the [Text] in this widget.
  final bool isTimerTextShown;

  CircularCountDownTimer({
    @required this.width,
    @required this.height,
    @required this.duration,
    @required this.fillColor,
    @required this.color,
    this.isReverse,
    this.onComplete,
    this.strokeWidth,
    this.textStyle,
    this.isTimerTextShown = true,
  })  : assert(width != null),
        assert(height != null),
        assert(duration != null),
        assert(fillColor != null),
        assert(color != null);

  @override
  _CircularCountDownTimerState createState() => _CircularCountDownTimerState();
}

class _CircularCountDownTimerState extends State<CircularCountDownTimer>
    with TickerProviderStateMixin {
  AnimationController controller;

  String get time {
    if (widget.isReverse && controller.isDismissed) {
      return '0:00';
    } else {
      Duration duration = controller.duration * controller.value;
      return _getTime(duration);
    }
  }

  void _startAnimation() {
    if (widget.isReverse) {
      controller.reverse(from: 1.0);
    } else {
      controller.forward();
    }
  }

  String _getTime(Duration duration) {
    // For HH:mm:ss format
    if (duration.inHours != 0) {
      return '${duration.inHours}:${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    // For mm:ss format
    else {
      return '${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
  }

  void _onComplete() {
    if (widget.onComplete != null) widget.onComplete();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    );

    controller.addStatusListener((status) {
      switch (status) {
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

    _startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.center,
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: CustomPaint(
                                    painter: CustomTimerPainter(
                                      animation: controller,
                                      fillColor: widget.fillColor,
                                      color: widget.color,
                                      strokeWidth: widget.strokeWidth,
                                    ),
                                  ),
                                ),
                                widget.isTimerTextShown
                                    ? Align(
                                        alignment: FractionalOffset.center,
                                        child: Text(
                                          time,
                                          style: widget.textStyle ??
                                              TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black,
                                              ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }

  @override
  void dispose() {
    controller.stop();
    controller.dispose();
    super.dispose();
  }
}
