// providers/theme_notifier.dart

import 'package:checklist/themes/build_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeData _themeData;
  String _backgroundImage;

  ThemeNotifier(this._themeData, this._backgroundImage);

  ThemeData get themeData => _themeData;
  String get backgroundImage => _backgroundImage;

  void setTheme(ThemeData themeData, String backgroundImage) {
    _themeData = themeData;
    _backgroundImage = backgroundImage;

    // Update text style based on background image
    _themeData = _themeData.copyWith(
      textTheme: TextTheme(
        bodyText1: StyleConfig.backgroundTextStyles[backgroundImage] ?? TextStyle(),
      ),
    );

    notifyListeners();
  }
}

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
