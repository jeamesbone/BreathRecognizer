# Breath Recognizer

An example of a swift class to record sound from the microphone and report whether the user is currently breathing into the mic.

It uses a combination of the average sound level and the peak level to (hopefully) remove background noise or spikes.

## How to use
Copy `BreathRecognizer.swift` into your Xcode project.

### Code Example
When you create a BreathRecognizer you provide it a threshold and a function to be called when the breathing state changes.

```swift
  // Specifty a threshold in decibels (-15 seems to work well for breath detection)
  BreathRecognizer(threshold) { isBreathing in
    doSomethingWithTheNewBreathingValue(isBreathing)
  }
```

Also see the example in `ViewController.swift`.

Note:
- The update function will only be called when the state changes (eg. breathing -> not breathing)
- The recognizer will poll for mic updates every 0.05 seconds, I found this to be reasonable but feel free to mess with this in your project.

Todo:
- Possibly provide a delegate interface for callbacks
- Add more customizability in the timing and weighting of the readings.
- Generalize this to detect different types of sound in addition to breathing (talking, clicking etc.).
