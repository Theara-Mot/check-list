import 'dart:convert';
import 'package:checklist/providers/theme_notifier.dart';
import 'package:checklist/screen/add_task.dart';
import 'package:checklist/screen/drawer/custom_drawer.dart';
import 'package:checklist/themes/build_theme.dart';
import 'package:checklist/widgets/build_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  List<Task> _taskList = [];
  List<bool> isCollapsed = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? taskListJson = prefs.getString('tasks');
    if (taskListJson != null) {
      List<dynamic> decoded = jsonDecode(taskListJson);
      setState(() {
        _taskList = decoded.map((taskJson) => Task.fromJson(taskJson)).toList();
        isCollapsed = List.generate(_taskList.length, (_) => true); // Initialize collapse state
      });
    }
  }

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
                    keyboardType: TextInputType.text,
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search here  . . . ',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (value) {
                      setState(() {
                        // Implement search functionality here if needed
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _taskList.length,
                  itemBuilder: (context, index) {
                    Task task = _taskList[index];
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
                                value: task.isAlarm,
                                onChanged: (newValue) {
                                  setState(() {
                                    task.isAlarm = newValue ?? false;
                                    // Save updated task state
                                  });
                                },
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(task.title, style: bodyMedium),
                                  if (task.dueDate != null)
                                    Text(
                                      DateFormat('dd-MM-yyyy HH:mm a').format(task.dueDate!),
                                      style: bodySmall,
                                    ),
                                ],
                              ),
                              Spacer(),
                              Text('${task.subtasks.where((subtask) => subtask.status).length}/${task.subtasks.length}', style: body),
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
                              itemCount: task.subtasks.length,
                              itemBuilder: (context, subIndex) {
                                SubTask subtask = task.subtasks[subIndex];
                                return Row(
                                  children: [
                                    Checkbox(
                                      activeColor: buttonColor,
                                      value: subtask.status,
                                      onChanged: (newValue) {
                                        setState(() {
                                          subtask.status = newValue ?? false;
                                          // Save updated subtask state
                                        });
                                      },
                                    ),
                                    Text(subtask.title)
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

class Task {
  String title;
  DateTime? dueDate;
  bool isAlarm;
  int priority;
  List<SubTask> subtasks;

  Task({
    required this.title,
    this.dueDate,
    this.isAlarm = false,
    this.priority = -1,
    this.subtasks = const [],
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      isAlarm: json['isAlarm'] ?? false,
      priority: json['priority'] ?? -1,
      subtasks: (json['subtasks'] as List<dynamic>?)
              ?.map((subtaskJson) => SubTask.fromJson(subtaskJson))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'dueDate': dueDate?.toIso8601String(),
      'isAlarm': isAlarm,
      'priority': priority,
      'subtasks': subtasks.map((subtask) => subtask.toJson()).toList(),
    };
  }
}

class SubTask {
  String title;
  bool status;

  SubTask({
    required this.title,
    this.status = false,
  });

  factory SubTask.fromJson(Map<String, dynamic> json) {
    return SubTask(
      title: json['title'],
      status: json['status'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'status': status,
    };
  }
}
