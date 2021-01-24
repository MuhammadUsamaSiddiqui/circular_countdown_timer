## Circular Countdown Timer

Make an animated circular countdown using Circular Countdown Timer.

## Getting Started

To use this plugin, add `circular_countdown_timer` as a [dependency in your pubspec.yaml file.](https://flutter.dev/docs/development/packages-and-plugins/using-packages)

## Features
* Forward Countdown Timer.
* Reverse Countdown Timer.
* Start, Pause, Resume and Restart Timer.

## Usage

```dart
CircularCountDownTimer(
     duration: 10,
     controller: CountDownController(),
     width: MediaQuery.of(context).size.width / 2,
     height: MediaQuery.of(context).size.height / 2,
     color: Colors.grey[300],
     fillColor: Colors.purpleAccent[100],
     backgroundColor: Colors.purple[500],
     strokeWidth: 20.0,
     strokeCap: StrokeCap.round,
     textStyle: TextStyle(
         fontSize: 33.0, color: Colors.white, fontWeight: FontWeight.bold),
     textFormat: CountdownTextFormat.SS,
     isReverse: false,
     isReverseAnimation: false,
     isTimerTextShown: true,
     autoStart: true,
     onStart: () {
         print('Countdown Started');
     },
     onComplete: () {
         print('Countdown Ended');
     },
 );
```

## Parameters
|Name|Type|Default Value|Description
|:-------------|:----------|:--------|:------------|
|`key`|`Key`|null|*Key for Countdown Timer.*|
|`duration`|`int`|null|*Countdown duration in Seconds.*|
|`controller`|`CountDownController`|null|*Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.*|
|`width`|`double`|null|*Width of the Countdown Widget.*|
|`height`|`double`|null|*Height of the Countdown Widget.*|
|`color`|`Color`|null|*Ring Color for Countdown Widget.*|
|`fillColor`|`Color`|null|*Filling Color for Countdown Widget.*|
|`backgroundColor`|`Color`|null|*Background Color for Countdown Widget.*|
|`strokeWidth`|`double`|5.0|*Border Thickness of the Countdown Ring.*|
|`strokeCap`|`StrokeCap`|StrokeCap.butt|*Begin and end contours with a flat edge and no extension.*|
|`textStyle`|`TextStyle`|TextStyle(fontSize: 16.0,color: Colors.black,)|*Text Style for Countdown Text.*|
|`textFormat`|`String`|null|*Format for the Countdown Text.*|
|`isReverse`|`bool`|false|*Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).*|
|`isReverseAnimation`|`bool`|false|*Handles Animation Direction (true for Reverse Animation, false for Forward Animation).*|
|`isTimerTextShown`|`bool`|true|*Handles visibility of the Countdown Text.*|
|`autoStart`|`bool`|true|*Handles the timer start.*|
|`onStart`|`VoidCallback`|null|*This Callback will execute when the Countdown Starts.*|
|`onComplete`|`VoidCallback`|null|*This Callback will execute when the Countdown Ends.*|

## Demo

![demo](https://user-images.githubusercontent.com/30389103/105608573-7e124880-5dc5-11eb-8d72-9b98ac14dbd9.gif)
