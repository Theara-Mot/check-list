import 'package:flutter/material.dart';

class ToastWidget {
  static void show(BuildContext context, String message) {
    final overlay = Overlay.of(context)?.context.findRenderObject() as RenderBox?;
    // final toastWidget = _buildToastWidget(message);

    final entry = OverlayEntry(builder: (context) {
      return Positioned(
        top: overlay!.size.height * 0.75,
        width: overlay.size.width,
        child: Material(
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
      );
    });

    Overlay.of(context)?.insert(entry);
    Future.delayed(Duration(seconds: 2), () {
      entry.remove();
    });
  }

  static Widget _buildToastWidget(String message) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Builder(builder: (context) {
        return Text(message);
      }),
    );
  }
}
