import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:checklist/widgets/build_background.dart';
import 'package:checklist/widgets/toast.dart';
import 'package:checklist/providers/theme_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/task.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _taskController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _isPermissionGranted = false;
  final List<Task> _taskList = [];
  final List<SubTask> _subtasks = [];
  int _selectedPriorityIndex = -1;
  bool isAlarm = false;

  Future<void> _requestPermission() async {
    bool permission = await _speech.initialize(
      onError: (e) => print('Error: $e'),
    );
    setState(() {
      _isPermissionGranted = permission;
    });
  }

  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _titleController.text = val.recognizedWords;
          }),
        );
      } else {
        print("The user has denied the use of speech recognition.");
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _selectDate(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Date and Time',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: _selectedDate,
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      _selectedDate = newDate;
                    });
                  },
                  use24hFormat: false,
                  mode: CupertinoDatePickerMode.dateAndTime,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _speech.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _requestPermission();
    _loadTasks(); // Load tasks on initialization
  }

  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? taskListJson = prefs.getString('tasks');
    if (taskListJson != null) {
      List<dynamic> decoded = jsonDecode(taskListJson);
      setState(() {
        _taskList.clear();
        _taskList.addAll(decoded.map((taskJson) => Task.fromJson(taskJson)).toList());
      });
    }
  }

  Future<void> _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> taskListJson = _taskList.map((task) => task.toJson()).toList();
    await prefs.setString('tasks', jsonEncode(taskListJson));
  }

  Future<void> _addTask() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _taskList.add(Task(
          title: _titleController.text,
          dueDate: DateFormat('dd-MM-yyyy HH:mm a').format(_selectedDate),
          isAlarm: isAlarm,
          priority: _selectedPriorityIndex,
          subtasks: _subtasks,
        ));
        _titleController.clear();
        _taskController.clear();
        _selectedPriorityIndex = -1;
        isAlarm = false;
        _selectedDate = DateTime.now();
        _subtasks.clear();
      });
      await _saveTasks(); // Save tasks after adding a new task
    }
  }

  void _removeTask(int index) async {
    setState(() {
      _taskList.removeAt(index);
    });
    await _saveTasks(); // Save tasks after removing a task
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
    Color containerColor =
        themeNotifier.themeData.cardTheme.color ?? Colors.white;

    return AppBackground(
      backgroundImage: themeNotifier.backgroundImage,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: iconColor),
          ),
          title: Text('Add Task', style: appbarStyle),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 10),
                  Text('Priority', style: bodyMedium),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPriorityCheckbox(0, 'Low'),
                      _buildPriorityCheckbox(1, 'Medium'),
                      _buildPriorityCheckbox(2, 'High'),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Due date', style: bodyMedium),
                      Text('Alarm', style: body),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 0,
                          margin: EdgeInsets.zero,
                          color: themeNotifier.containerColor,
                          child: ListTile(
                            title: Text(
                              "${DateFormat('dd-MM-yyyy HH:mm a').format(_selectedDate)}",
                              style: bodyMedium,
                            ),
                            trailing: Icon(Icons.keyboard_arrow_down),
                            onTap: () => _selectDate(context),
                          ),
                        ),
                      ),
                      Checkbox(
                        activeColor: Colors.green,
                        checkColor: Colors.white,
                        value: isAlarm,
                        onChanged: (bool? value) {
                          setState(() {
                            isAlarm = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Title', style: bodyMedium),
                      Text(
                        _speech.isListening ? 'Listening ...' : '',
                        style: bodyMedium,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 0,
                          color: themeNotifier.containerColor,
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 12),
                            child: TextFormField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                hintText: 'Enter task title here',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: _listen,
                        child: Icon(
                          Icons.keyboard_voice_sharp,
                          size: 30,
                          color: iconColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text('Subtasks', style: bodyMedium),
                  Card(
                    elevation: 0,
                    color: themeNotifier.containerColor,
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              controller: _taskController,
                              decoration: InputDecoration(
                                hintText: 'Enter subtask here',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, color: iconColor),
                            onPressed: () {
                              if (_taskController.text.isEmpty) {
                                FocusScope.of(context).unfocus();
                                ToastWidget.show(context, 'Please input a subtask');
                              } else {
                                setState(() {
                                  _subtasks.add(SubTask(title: _taskController.text, status: false));
                                  _taskController.clear();
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_subtasks.isNotEmpty) SizedBox(height: 5),
                  if (_subtasks.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white.withOpacity(0.5),
                      ),
                      child: ReorderableListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        onReorder: (int oldIndex, int newIndex) {
                          setState(() {
                            if (newIndex > oldIndex) {
                              newIndex -= 1;
                            }
                            final item = _subtasks.removeAt(oldIndex);
                            _subtasks.insert(newIndex, item);
                          });
                        },
                        children: [
                          for (int index = 0; index < _subtasks.length; index++)
                            ListTile(
                              key: Key(_subtasks[index].title),
                              title: Text(
                                _subtasks[index].title,
                                style: bodyMedium,
                              ),
                              trailing: Icon(Icons.drag_handle, color: iconColor),
                            ),
                        ],
                      ),
                    ),
                  SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: buttonColor,
                    ),
                    child: InkWell(
                      splashColor: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(30),
                      onTap: _addTask,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityCheckbox(int index, String label) {
    var themeNotifier = context.read(themeNotifierProvider);
    Color iconColor = themeNotifier.iconColor;
    TextStyle bodyMedium = themeNotifier.themeData.textTheme.displayMedium!;
    return Row(
      children: [
        Checkbox(
          activeColor: Colors.green,
          checkColor: Colors.white,
          value: _selectedPriorityIndex == index,
          onChanged: (bool? value) {
            setState(() {
              _selectedPriorityIndex = index;
            });
          },
        ),
        Text(
          label,
          style: bodyMedium.copyWith(color: iconColor),
        ),
      ],
    );
  }
}

class Task {
  String title;
  String? dueDate;
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
      dueDate: json['dueDate'].toString() ??'',
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
      'dueDate': dueDate,
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
