import 'package:checklist/providers/theme_notifier.dart';
import 'package:checklist/screen/drawer/custom_drawer.dart';
import 'package:checklist/screen/task_screen.dart';
import 'package:checklist/themes/build_theme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'cost/color.dart';

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  final List<String> _backgroundImages = [
    'assets/background_images/background1.jpg',
    'assets/background_images/background2.jpg',
    'assets/background_images/background1.jpg',
    'assets/background_images/background2.jpg',
  ];

void _showBottomModal(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 230,
        color: Colors.transparent,
        child: ListView.builder(
          padding: EdgeInsets.all(12),
          scrollDirection: Axis.horizontal,
          itemCount: _backgroundImages.length,
          itemBuilder: (context, index) {
            String image = _backgroundImages[index];
            return GestureDetector(
              onTap: (){
                var themeNotifier = context.read(themeNotifierProvider);
                themeNotifier.setTheme(themeNotifier.themeData, image);
                setState(() {});
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.all(8),
                width: 150,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(image)
                  )
                ),
              ),
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
          centerTitle: false,
          title: Text('Check List', style: textStyle),
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.sort, color: Colors.white),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.color_lens),
              onPressed: () => _showBottomModal(context),
            ),
          ],
        ),
        drawer: const CustomDrawerLeave(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.appbar,
          foregroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaskCreationScreen()),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
