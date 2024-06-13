import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme_notifier.dart';

final themeNotifierProvider = ChangeNotifierProvider<ThemeNotifier>((ref) {
  return ThemeNotifier(
    ThemeData(
      primarySwatch: Colors.blue,
      textTheme: TextTheme(
        bodyText1: TextStyle(color: Colors.black),
      ),
    ),
    'assets/background_images/background1.jpg',
  );
});
