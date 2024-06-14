import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class AppBackground extends StatelessWidget {
  final Widget child;
  final String backgroundImage;

  const AppBackground({super.key, required this.child, required this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ImageFiltered(
          imageFilter: ui.ImageFilter.blur(sigmaX: 2, sigmaY: 2.5),
          child: Image.asset(
            backgroundImage,
            fit: BoxFit.cover,
          ),
        ),
        child,
      ],
    );
  }
}
