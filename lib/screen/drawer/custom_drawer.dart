
import 'package:checklist/screen/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_listtile.dart';
import 'header.dart';


class CustomDrawerLeave extends StatefulWidget {
  const CustomDrawerLeave({Key? key}) : super(key: key);

  @override
  State<CustomDrawerLeave> createState() => _CustomDrawerLeaveState();
}

class _CustomDrawerLeaveState extends State<CustomDrawerLeave> {
  bool _isCollapsed = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        curve: Curves.easeInOutCubic,
        duration: const Duration(milliseconds: 500),
        width: _isCollapsed ? 300 : 70,
        margin: const EdgeInsets.only(bottom: 10, top: 10,left: 10,right: 10),
        decoration:const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(3),
            bottomRight: Radius.circular(12),
            bottomLeft: Radius.circular(3),
          ),
          color:Color.fromRGBO(152, 167, 125, 0.85),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomDrawerHeader(isColapsed: _isCollapsed),
              const Divider(
                color: Colors.white,
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.bookmarks,
                title: 'History',
                infoCount: 0,
                doHaveMoreOptions: Icons.arrow_forward_ios,
                route: HomeScreen(),
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.folder_shared,
                title: 'Folder',
                infoCount: 0,
                doHaveMoreOptions: Icons.arrow_forward_ios,
                route: HomeScreen(),
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.space_dashboard_rounded,
                title: 'Dashboard',
                infoCount: 0,
                doHaveMoreOptions: Icons.arrow_forward_ios,
                route: HomeScreen(),
              ),
              SizedBox(height: 10,),
              Spacer(),
              Text(_isCollapsed?'About':'A . . .',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w600),),
              SizedBox(height: 10,),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.share,
                title: 'Share App',
                infoCount: 0,
                doHaveMoreOptions: Icons.arrow_forward_ios,
                route: HomeScreen(),
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.feedback_sharp,
                title: 'Send Feedback',
                infoCount: 0,
                doHaveMoreOptions: Icons.arrow_forward_ios,
                route: HomeScreen(),
              ),
              SizedBox(height: 20,),
              Text(_isCollapsed?'Follow Us':'F . . .',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w600),),
              SizedBox(height: 10,),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.facebook,
                title: 'Facebook',
                infoCount: 0,
                doHaveMoreOptions: Icons.arrow_forward_ios,
                route: HomeScreen(),
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.tiktok,
                title: 'Tik Tok',
                infoCount: 0,
                doHaveMoreOptions: Icons.arrow_forward_ios,
                route: HomeScreen(),
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.telegram,
                title: 'Telegram',
                infoCount: 0,
                doHaveMoreOptions: Icons.arrow_forward_ios,
                route: HomeScreen(),
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: CupertinoIcons.globe,
                title: 'Website',
                infoCount: 0,
                doHaveMoreOptions: Icons.arrow_forward_ios,
                route: HomeScreen(),
              ),
              SizedBox(height: 20,),
              Text(_isCollapsed?'Version : 1.0.0':'',style: TextStyle(color: Colors.white.withOpacity(0.5),fontWeight: FontWeight.w500),),
              Align(
                alignment: _isCollapsed
                    ? Alignment.bottomRight
                    : Alignment.bottomCenter,
                child: IconButton(
                  splashColor: Colors.transparent,
                  icon: Icon(
                    _isCollapsed
                        ? Icons.arrow_back_ios
                        : Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                  onPressed: () {
                    setState(() {
                      _isCollapsed = !_isCollapsed;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}