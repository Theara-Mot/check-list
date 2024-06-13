// config.dart

import 'package:flutter/material.dart';

class StyleConfig {
  static final Map<String, TextStyle> backgroundTextStyles = {
    'assets/background_images/background1.jpg': TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    'assets/background_images/background2.jpg': TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    // Add more styles for additional backgrounds here
  };
}
