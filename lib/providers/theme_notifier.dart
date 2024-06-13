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
  Color _containerColor;

  ThemeNotifier(this._themeData, this._backgroundImage, this._iconColor,this._drawerColor,this._buttonColor,this._containerColor);

  ThemeData get themeData => _themeData;
  String get backgroundImage => _backgroundImage;
  Color get iconColor => _iconColor;
  Color get drawerColor => _drawerColor;
  Color get buttonColor => _buttonColor;
  Color get containerColor => _containerColor;
  void setTheme(int index) {
    _backgroundImage = AppTheme.themeStyle[index]['bg'];
    _iconColor = AppTheme.themeStyle[index]['icon-color'];
    _drawerColor = AppTheme.themeStyle[index]['drawer-color'];
    _buttonColor = AppTheme.themeStyle[index]['button-color'];
    _containerColor = AppTheme.themeStyle[index]['container-color'];
    _themeData = ThemeData(
      primarySwatch: Colors.blue,
      textTheme: TextTheme(
        bodySmall: AppTheme.themeStyle[index]['small-text'],
        bodyMedium: AppTheme.themeStyle[index]['normal-text'],
        displayMedium: AppTheme.themeStyle[index]['big-text'],
        displayLarge: AppTheme.themeStyle[index]['app-bar']
      ),
      iconTheme: IconThemeData(color: _iconColor),
      buttonTheme: ButtonThemeData(buttonColor: _buttonColor),
      cardColor: _containerColor,
      cardTheme:CardTheme(color:_containerColor),
    );

    notifyListeners();
  }
}

final themeNotifierProvider = ChangeNotifierProvider<ThemeNotifier>((ref) {
  return ThemeNotifier(
    ThemeData(
      primarySwatch: Colors.blue,
      textTheme: TextTheme(
          bodySmall: AppTheme.themeStyle[0]['small-text'],
          displaySmall: AppTheme.themeStyle[0]['normal-text'],
          displayMedium: AppTheme.themeStyle[0]['big-text'],
          displayLarge: AppTheme.themeStyle[0]['app-bar']
      ),
      iconTheme: IconThemeData(color: AppTheme.themeStyle[0]['button-color']),
      cardTheme: CardTheme(color:AppTheme.themeStyle[0]['container-color']),
    ),
      AppTheme.themeStyle[0]['bg'],
      AppTheme.themeStyle[0]['icon-color'],
      AppTheme.themeStyle[0]['drawer-color'],
      AppTheme.themeStyle[0]['button-color'],
      AppTheme.themeStyle[0]['container-color'],
  );
});
