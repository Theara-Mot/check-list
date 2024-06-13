import 'package:checklist/cost/color.dart';
import 'package:flutter/material.dart';

class BuildAppBar extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool isShowback;

  BuildAppBar({
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.isShowback = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.body,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Color(0xff0066b2),
        leading: isShowback
            ? GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        )
            : null,
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: actions,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
