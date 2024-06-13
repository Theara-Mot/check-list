// config.dart

import 'package:checklist/cost/color.dart';
import 'package:flutter/material.dart';

class StyleConfig {
  static final Map<String, TextStyle> backgroundTextStyles = {
    'assets/background_images/background1.jpg': TextStyle(
      color: Colors.black,
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

class AppTheme {
  static final List<Map<String, dynamic>> themeStyle =[
    {
      'bg':'assets/background_images/background1.jpg',
      'style' :TextStyle(color: AppColors.appbar,fontSize: 16,fontWeight: FontWeight.bold),
      'icon-color':AppColors.appbar,
      'drawer-color':AppColors.appbar.withOpacity(0.5),
      'button-color':AppColors.appbar,
      'name':'style 1'
    },
    {
      'bg':'assets/background_images/background2.jpg',
      'style' :TextStyle(color: Color.fromARGB(255, 248, 1, 228),fontSize: 16,fontWeight: FontWeight.bold),
      'icon-color':Color.fromARGB(255, 211, 129, 204),
      'drawer-color':Color.fromARGB(255, 236, 9, 217),
      'button-color':Color.fromARGB(255, 236, 9, 217),
      'name':'style 2'
    },
    {
      'bg':'assets/background_images/bgg.webp',
      'style' :TextStyle(color: Colors.red,fontSize: 16,fontWeight: FontWeight.bold),
      'icon-color':Color.fromARGB(255, 194, 177, 84),
      'drawer-color':Color.fromARGB(255, 224, 221, 7),
      'button-color':Color.fromARGB(255, 224, 221, 7),
      'name':'style 3'
    },
  ];
}