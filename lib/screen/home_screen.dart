import 'package:checklist/providers/theme_notifier.dart';
import 'package:checklist/screen/add_task.dart';
import 'package:checklist/screen/drawer/custom_drawer.dart';
import 'package:checklist/screen/task_screen.dart';
import 'package:checklist/themes/build_theme.dart';
import 'package:checklist/widgets/build_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  List<bool> isCollapsed = List.generate(2, (_) => true); // Initial state for collapse/expand

  void _showBottomModal(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        var themeNotifier = context.read(themeNotifierProvider);
        TextStyle textStyle = themeNotifier.themeData.textTheme.bodyText1!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text('Appearance', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 230,
              color: Colors.transparent,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                scrollDirection: Axis.horizontal,
                itemCount: AppTheme.themeStyle.length,
                itemBuilder: (context, index) {
                  String image = AppTheme.themeStyle[index]['bg'];
                  String name = AppTheme.themeStyle[index]['name'];
                  return GestureDetector(
                    onTap: () {
                      themeNotifier.setTheme(index);
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.all(8),
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(image),
                            ),
                          ),
                        ),
                        Text(
                          name,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = context.read(themeNotifierProvider);
    TextStyle body = themeNotifier.themeData.textTheme.displaySmall!;
    TextStyle appbarStyle = themeNotifier.themeData.textTheme.displayLarge!;
    TextStyle bodyMedium = themeNotifier.themeData.textTheme.displayMedium!;
    TextStyle bodySmall = themeNotifier.themeData.textTheme.bodySmall!;
    Color iconColor = themeNotifier.iconColor;
    Color buttonColor = themeNotifier.buttonColor;
    Color containerColor = themeNotifier.themeData.cardTheme.color ?? Colors.white;

    return AppBackground(
      backgroundImage: themeNotifier.backgroundImage,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: false,
          title: Text('Check List', style: appbarStyle),
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.sort, color: iconColor),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.color_lens, color: iconColor),
              onPressed: () => _showBottomModal(context),
            ),
          ],
        ),
        drawer: const CustomDrawerLeave(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTask()),
            );
          },
          child: Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Card(
                elevation: 0,
                color: containerColor,
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search here  . . . ',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(8.0),
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: containerColor,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                activeColor: buttonColor,
                                value: false,
                                onChanged: (newValue) {
                                  // Handle checkbox state change
                                },
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Welcome to Task!', style: bodyMedium),
                                  Text('Today 11.27 PM', style: bodySmall),
                                ],
                              ),
                              Spacer(),
                              Text('0/4', style: body),
                              SizedBox(width: 8),
                              CircleAvatar(
                                backgroundColor: Colors.grey.withOpacity(0.1),
                                child: IconButton(
                                  icon: Icon(
                                    isCollapsed[index] ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isCollapsed[index] = !isCollapsed[index];
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          AnimatedCrossFade(
                            firstChild: Container(),
                            secondChild: ListView.builder(
                              padding: EdgeInsets.only(left: 30),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    Checkbox(
                                      activeColor: buttonColor,
                                      value: false,
                                      onChanged: (newValue) {
                                        // Handle checkbox state change
                                      },
                                    ),
                                    Text('data ${index + 1}')
                                  ],
                                );
                              },
                            ),
                            crossFadeState: isCollapsed[index] ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                            duration: Duration(milliseconds: 350),
                          ),
                        ],
                      ),
                    );
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
