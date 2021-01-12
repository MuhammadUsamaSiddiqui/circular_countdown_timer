library circular_countdown_timer;

import 'package:flutter/material.dart';
import 'custom_timer_painter.dart';

/// Create a Circular Countdown Timer
class CircularCountDownTimer extends StatefulWidget {
  /// Key for Countdown Timer
  final Key key;

  /// Filling Color for Countdown Timer
  final Color fillColor;

  /// Default Color for Countdown Timer
  final Color color;

  /// Background Color for Countdown Widget
  final Color backgroundColor;

  /// Function which will execute when the Countdown Ends
  final Function onComplete;

  /// Countdown Duration in Seconds
  final int duration;

  /// Countdown initial elapsed Duration in Seconds
  final int initialDuration;

  /// Width of the Countdown Widget
  final double width;

  /// Height of the Countdown Widget
  final double height;

  /// Border Thickness of the Countdown Circle
  final double strokeWidth;

  /// Begin and end contours with a flat edge and no extension
  final StrokeCap strokeCap;

  /// Text Style for Countdown Text
  final TextStyle textStyle;

  /// true for reverse countdown (max to 0), false for forward countdown (0 to max)
  final bool isReverse;

  /// true for reverse animation, false for forward animation
  final bool isReverseAnimation;

  /// Optional [bool] to hide the [Text] in this widget.
  final bool isTimerTextShown;

  /// Controller to control (i.e Pause, Resume, Restart) the Countdown
  final CountDownController controller;

  CircularCountDownTimer({
    @required this.width,
    @required this.height,
    @required this.duration,
    @required this.fillColor,
    @required this.color,
    this.backgroundColor,
    this.isReverse = false,
    this.isReverseAnimation = false,
    this.onComplete,
    this.strokeWidth,
    this.strokeCap,
    this.textStyle,
    this.key,
    this.isTimerTextShown = true,
    this.controller,
    this.initialDuration = 0,
  })  : assert(width != null),
        assert(height != null),
        assert(duration != null),
        assert(fillColor != null),
        assert(color != null),
        super(key: key);

  @override
  CircularCountDownTimerState createState() => CircularCountDownTimerState();
}

class CircularCountDownTimerState extends State<CircularCountDownTimer>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _countDownAnimation;

  String get time {
    if (widget.isReverse && _controller.isDismissed) {
      return '0:00';
    } else {
      Duration duration = _controller.duration * _controller.value;
      return _getTime(duration);
    }
  }

  void _setAnimation() {
    if (widget.isReverse) {
      _controller.reverse(from: 1);
    } else {
      _controller.forward();
    }
  }

  void _setAnimationDirection() {
    if ((!widget.isReverse && widget.isReverseAnimation) ||
        (widget.isReverse && !widget.isReverseAnimation)) {
      _countDownAnimation =
          Tween<double>(begin: 1, end: 0).animate(_controller);
    }
  }

  void _setController() {
    widget.controller?._state = this;
    widget.controller?._isReverse = widget.isReverse;
    if (widget.initialDuration > 0) {
      _controller?.value = (widget.initialDuration / widget.duration);
      widget.controller?.resume();
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
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    );

    _controller.addStatusListener((status) {
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

    _setAnimation();
    _setAnimationDirection();
    _setController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
          animation: _controller,
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
                                        animation:
                                            _countDownAnimation ?? _controller,
                                        fillColor: widget.fillColor,
                                        color: widget.color,
                                        strokeWidth: widget.strokeWidth,
                                        strokeCap: widget.strokeCap,
                                        backgroundColor:
                                            widget.backgroundColor),
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
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }
}

/// Controller for controlling Countdown Widget (i.e Pause, Resume, Restart)
class CountDownController {
  CircularCountDownTimerState _state;
  bool _isReverse;

  /// This Method Pauses the Countdown Timer
  void pause() {
    _state._controller?.stop(canceled: false);
  }

  /// This Method Resumes the Countdown Timer
  void resume() {
    if (_isReverse) {
      _state._controller
          ?.reverse(from: _state._controller.value = _state._controller.value);
    } else {
      _state._controller?.forward(from: _state._controller.value);
    }
  }

  /// This Method Restarts the Countdown Timer,
  /// Here optional int parameter **duration** is the updated duration for countdown timer

  void restart({int duration}) {
    _state._controller.duration =
        Duration(seconds: duration ?? _state._controller.duration.inSeconds);
    if (_isReverse) {
      _state._controller?.reverse(from: 1);
    } else {
      _state._controller?.forward(from: 0);
    }
  }

  /// This Method returns the **Current Time** of Countdown Timer i.e
  /// Time Used in terms of **Forward Countdown** and Time Left in terms of **Reverse Countdown**

  String getTime() {
    return _state
        ._getTime(_state._controller.duration * _state._controller?.value);
  }
}
