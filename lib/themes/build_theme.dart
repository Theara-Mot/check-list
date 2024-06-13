import 'package:checklist/cost/color.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final List<Map<String, dynamic>> themeStyle =[
    {
      'bg':'assets/background_images/background1.jpg',
      'app-bar' :TextStyle(color: Color.fromARGB(255, 54, 87, 3),fontSize: 22,fontWeight: FontWeight.w500),
      'big-text' :TextStyle(color: Color.fromARGB(255, 54, 87, 3),fontSize: 18,fontWeight: FontWeight.w500),
      'normal-text' :TextStyle(color: Colors.grey,fontSize: 16),
      'small-text' :TextStyle(color:Colors.grey,fontSize: 12),
      'icon-color':Color.fromARGB(255, 54, 87, 3),
      'drawer-color':Color.fromARGB(200, 152, 167, 125),
      'button-color':Color.fromARGB(255, 54, 87, 3),
      'name':'style 1',
      'container-color':Color.fromARGB(145, 221, 241, 188)
    },
    {
      'bg':'assets/background_images/background2.jpg',
      'app-bar' :TextStyle(color: Color.fromARGB(255, 54, 87, 3),fontSize: 22,fontWeight: FontWeight.w500),
      'big-text' :TextStyle(color: Color.fromARGB(255, 54, 87, 3),fontSize: 18,fontWeight: FontWeight.w500),
      'normal-text' :TextStyle(color: Colors.grey,fontSize: 16),
      'small-text' :TextStyle(color:Colors.grey,fontSize: 12),
      'icon-color':Color.fromARGB(255, 211, 129, 204),
      'drawer-color':Color.fromARGB(255, 236, 9, 217),
      'button-color':Color.fromARGB(255, 236, 9, 217),
      'name':'style 2',
      'container-color':Color.fromARGB(203, 241, 234, 239)
    },
    {
      'bg':'assets/background_images/bgg.webp',
      'app-bar' :TextStyle(color: Color.fromARGB(255, 54, 87, 3),fontSize: 22,fontWeight: FontWeight.w500),
      'big-text' :TextStyle(color: Color.fromARGB(255, 54, 87, 3),fontSize: 18,fontWeight: FontWeight.w500),
      'normal-text' :TextStyle(color:Colors.grey,fontSize: 16),
      'small-text' :TextStyle(color:Colors.grey,fontSize: 12),
      'icon-color':Color.fromARGB(255, 136, 159, 94),
      'drawer-color':Color.fromARGB(255, 224, 221, 7),
      'button-color':Color.fromARGB(255, 224, 221, 7),
      'name':'style 3',
      'container-color':Color.fromARGB(204, 234, 224, 218)
    },
  ];
}