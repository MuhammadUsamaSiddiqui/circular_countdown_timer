## [0.0.9] - Jan 24 2021.

* Added Optional Parameter:
    * bool named **autoStart** to handle timer start.
    * String named **textFormat** to format Countdown Text.
    * VoidCallback named **onStart** which will execute when the Countdown Starts.

## [0.0.8] - Dec 05 2020.

* Fixed **key** issue.
* Added **getTime** method in CountDownController to get the **Current Time** of Countdown Timer.
* Added Optional Parameter StrokeCap named **strokeCap** for countdown begin and end contours.

## [0.0.7] - Sep 26 2020.

* Added Optional Parameter:
    * Key named **key** for Countdown Timer.
    * bool named **isReverseAnimation** to handle Animation Direction i.e Forward or Reverse.

* Added optional int parameter named **duration** in **restart** method of CountDownController, to restart the countdown with new duration.

## [0.0.6] - Sep 06 2020.

* Added optional Color parameter **backgroundColor** to change Background Color of Countdown Widget.
* Added optional CountDownController parameter **controller** to control (i.e Pause, Resume, Restart) the Countdown Timer.

## [0.0.5] - Aug 15 2020.

* Contribution by [Joshua de Guzman](https://github.com/joshuadeguzman)
    * Added optional bool parameter **isTimerTextShown** to hide and show Timer Text.
    * Refactor Logic for Animation.

## [0.0.4] - Jun 15 2020.

* Added support to show **Hours** in Countdown Text.

## [0.0.3] - Jun 13 2020.

* Changed Parameter name from:
    * **countdownTextStyle** to **textStyle**.
    * **reverseOrder** to **isReverse**.
    * **onCountDownComplete** to **onComplete**.

## [0.0.2] - Jun 08 2020.

* Fixed Crash on **onCountDownComplete**.

## [0.0.1] - Apr 28 2020.

* Initial release.
