import 'package:checklist/providers/theme_notifier.dart';
import 'package:checklist/themes/build_theme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  final List<String> _backgroundImages = [
    'assets/background_images/background1.jpg',
    'assets/background_images/background2.jpg',
    // Add more background images as needed
  ];

void _showBottomModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 200, // Set a fixed height for the modal
        child: ListView.builder(
          itemCount: _backgroundImages.length,
          itemBuilder: (context, index) {
            String image = _backgroundImages[index];
            return ListTile(
              leading: Image.asset(image, width: 50, height: 50, fit: BoxFit.cover),
              title: Text('Background ${index + 1}'),
              onTap: () {
                var themeNotifier = context.read(themeNotifierProvider);
                ThemeData newTheme = ThemeData(
                  primarySwatch: Colors.blue,
                  textTheme: TextTheme(
                    bodyText1: StyleConfig.backgroundTextStyles[image] ?? TextStyle(color: Colors.white),
                  ),
                );
                themeNotifier.setTheme(newTheme, image);
                Navigator.pop(context);
              },
            );
          },
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    var themeNotifier = context.read(themeNotifierProvider);
    TextStyle textStyle = themeNotifier.themeData.textTheme.bodyText1!;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(themeNotifier.backgroundImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('New Task', style: textStyle),
          actions: [
            IconButton(
              icon: Icon(Icons.color_lens),
              onPressed: () => _showBottomModal(context),
            ),
          ],
        ),
      ),
    );
  }
}
