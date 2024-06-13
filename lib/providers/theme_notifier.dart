import 'package:checklist/cost/color.dart';
import 'package:checklist/themes/build_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeData _themeData;
  String _backgroundImage;
  Color _iconColor;
  Color _drawerColor;
  Color _buttonColor;

  ThemeNotifier(this._themeData, this._backgroundImage, this._iconColor,this._drawerColor,this._buttonColor);

  ThemeData get themeData => _themeData;
  String get backgroundImage => _backgroundImage;
  Color get iconColor => _iconColor;
  Color get drawerColor => _drawerColor;
  Color get buttonColor => _buttonColor;

  void setTheme(int index) {
    _backgroundImage = AppTheme.themeStyle[index]['bg'];
    _iconColor = AppTheme.themeStyle[index]['icon-color'];
    _drawerColor = AppTheme.themeStyle[index]['drawer-color'];
    _buttonColor = AppTheme.themeStyle[index]['button-color'];
    _themeData = ThemeData(
      primarySwatch: Colors.blue,
      textTheme: TextTheme(
        bodyText1: AppTheme.themeStyle[index]['style'],
      ),
      iconTheme: IconThemeData(color: _iconColor),
    );

    notifyListeners();
  }
}

final themeNotifierProvider = ChangeNotifierProvider<ThemeNotifier>((ref) {
  return ThemeNotifier(
    ThemeData(
      primarySwatch: Colors.blue,
      textTheme: TextTheme(
        bodyText1: TextStyle(color: AppColors.appbar),
      ),
      iconTheme: IconThemeData(color: AppColors.appbar),
    ),
    'assets/background_images/background1.jpg',
    AppColors.appbar,AppColors.appbar,AppColors.appbar
  );
});
