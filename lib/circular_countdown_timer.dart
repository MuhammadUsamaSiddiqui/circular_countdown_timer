library circular_countdown_timer;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

  CircularCountDownTimer(
      {@required this.width,
      @required this.height,
      @required this.duration,
      @required this.fillColor,
      @required this.color,
      this.isReverse,
      this.onComplete,
      this.strokeWidth,
      this.textStyle})
      : assert(width != null),
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

  bool flag = true;
  String time;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    _setTimeFormat(duration);
    time = _getTime(duration);
    return time;
  }

  void _setTimeFormat(Duration duration) {
    if (duration.inHours != 0) {
      // For HH:mm:ss format
      time =
          '${duration.inHours}:${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    } else {
      // For mm:ss format
      time =
          '${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
  }

  String _getTime(Duration duration) {
    if (widget.isReverse == null || !widget.isReverse) {
      // For Forward Countdown
      Duration forwardDuration = Duration(seconds: widget.duration);
      if (forwardDuration.inSeconds == duration.inSeconds && flag) {
        flag = false;
        _callOnComplete();
        return time;
      }
      return time;
    } else {
      // For Reverse Countdown
      if (controller.isDismissed && flag) {
        flag = false;
        _callOnComplete();
        return '0:00';
      }
      return time;
    }
  }

  void _callOnComplete() {
    if (widget.onComplete != null) {
      SchedulerBinding.instance
          .addPostFrameCallback((_) => widget.onComplete());
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    );

    _setAnimation();
  }

  void _setAnimation() {
    if (widget.isReverse == null || !widget.isReverse) {
      // Forward Animation
      controller.forward(from: controller.value);
    } else {
      // Reverse Animation
      controller.reverse(
          from: controller.value == 0.0 ? 1.0 : controller.value);
    }
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
                                          strokeWidth: widget.strokeWidth)),
                                ),
                                Align(
                                  alignment: FractionalOffset.center,
                                  child: Text(
                                    timerString,
                                    style: widget.textStyle ??
                                        TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black),
                                  ),
                                ),
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
