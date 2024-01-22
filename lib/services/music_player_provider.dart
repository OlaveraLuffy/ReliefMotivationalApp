import 'package:flutter/material.dart';

class MusicPlayerProvider extends ChangeNotifier {
  bool showVolumeSlider = true; // Add other properties as needed

  void toggleVolumeSlider() {
    showVolumeSlider = !showVolumeSlider;
    notifyListeners();
  }

// Add other methods and properties as needed
}
