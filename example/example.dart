import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:circular_countdown_timer/countdown_controller.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Circular Countdown Timer Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: 'Circular Countdown Timer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _duration = 10;
  final CountDownController _controller = CountDownController(
      duration: const Duration(seconds: 10),
      initialDuration: const Duration(seconds: 10));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: CircularCountDownTimer(
          // Countdown duration in Seconds.

          // Countdown initial elapsed Duration in Seconds.
          initialDuration: const Duration(seconds: 10),

          // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
          countdownController: _controller,

          // Width of the Countdown Widget.
          width: MediaQuery.of(context).size.width / 2,

          // Height of the Countdown Widget.
          height: MediaQuery.of(context).size.height / 2,

          // Ring Color for Countdown Widget.
          ringColor: Colors.grey[300]!,

          // Ring Gradient for Countdown Widget.
          ringGradient: null,

          // Filling Color for Countdown Widget.
          fillColor: Colors.purpleAccent[100]!,

          // Filling Gradient for Countdown Widget.
          fillGradient: null,

          // Background Color for Countdown Widget.
          backgroundColor: Colors.purple[500],

          // Background Gradient for Countdown Widget.
          backgroundGradient: null,

          // Border Thickness of the Countdown Ring.
          strokeWidth: 20.0,

          // Begin and end contours with a flat edge and no extension.
          strokeCap: StrokeCap.round,

          // Text Style for Countdown Text.
          textStyle: const TextStyle(
            fontSize: 33.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),

          // Text Align for Countdown Text.
          textAlign: TextAlign.justify,

          // Format for the Countdown Text.
          textFormat: CountdownTextFormat.S,

          // Handles visibility of the Countdown Text.
          isTimerTextShown: true,


          // This Callback will execute when the Countdown Starts.
          onStart: () {
            // Here, do whatever you want
            debugPrint('Countdown Started');
          },

          // This Callback will execute when the Countdown Ends.
          onComplete: () {
            // Here, do whatever you want
            debugPrint('Countdown Ended');
          },

          // This Callback will execute when the Countdown Changes.
          onChange: (String timeStamp) {
            // Here, do whatever you want
            debugPrint('Countdown Changed $timeStamp');
          },

          /* 
            * Function to format the text.
            * Allows you to format the current duration to any String.
            * It also provides the default function in case you want to format specific moments
              as in reverse when reaching '0' show 'GO', and for the rest of the instances follow 
              the default behavior.
          */
          timeFormatterFunction: (defaultFormatterFunction, duration) {
            if (duration.inSeconds == 0) {
              // only format for '0'
              return "Start";
            } else {
              // other durations by it's default format
              return Function.apply(defaultFormatterFunction, [duration]);
            }
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 30,
          ),
          _button(
            title: "Start",
            onPressed: () => _controller.start(),
          ),
          const SizedBox(
            width: 10,
          ),
          _button(
            title: "Pause",
            onPressed: () => _controller.pause(),
          ),
          const SizedBox(
            width: 10,
          ),
          _button(
            title: "Resume",
            onPressed: () => _controller.resume(),
          ),
          const SizedBox(
            width: 10,
          ),
          _button(
            title: "Restart",
            onPressed: () => _controller.restart(duration: _duration),
          ),
        ],
      ),
    );
  }

  Widget _button({required String title, VoidCallback? onPressed}) {
    return Expanded(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.purple),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
