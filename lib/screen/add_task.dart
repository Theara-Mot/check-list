import 'package:checklist/providers/theme_notifier.dart';
import 'package:checklist/widgets/build_background.dart';
import 'package:checklist/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _taskController = TextEditingController();
  bool _isCompleted = false;
  DateTime _selectedDate = DateTime.now();
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _isPermissionGranted = false;
  final List<String> _taskList = [];
  int _selectedPriorityIndex = -1;
  bool isAlarm = false;

  final List<String> _backgroundImages = [
    'assets/background_images/background1.jpg',
    'assets/background_images/background2.jpg',
  ];

  @override
  void dispose() {
    _speech.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

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
                    Icon(Icons.close, color: Colors.red)
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

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _taskList.add(_taskController.text);
        _taskController.clear();
      });
    }
  }

  void _removeTask(int index) {
    setState(() {
      _taskList.removeAt(index);
    });
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: iconColor)),
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
                  ],),
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
                        activeColor:Colors.green,
                        checkColor: Colors.white,
                        value: isAlarm,
                        onChanged: (bool? value) {
                          setState(() {
                            isAlarm = !isAlarm;
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
                                hintText: 'Enter task here',
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
                      )
                    ],
                  ),
                
                  SizedBox(height: 20),
                  Text('Task', style: bodyMedium),
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
                                hintText: 'Enter task here',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, color: iconColor),
                            onPressed:(){
                              if(_taskController.text.isEmpty){
                                FocusScope.of(context).unfocus();
                              }
                              _taskController.text.isEmpty?ToastWidget.show(context, 'Please input prioriry'): _addTask();
                            },
                          )
                            
                        ],
                      ),
                    ),
                  ),
                  if(_taskList.length>1)
                    SizedBox(height: 5,),
                  if(_taskList.length>1)
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Text('Hold to reorder',style: bodySmall,),
                    Text('swipe right remove item',style: bodySmall,),
                  ]),
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
                          final item = _taskList.removeAt(oldIndex);
                          _taskList.insert(newIndex, item);
                        });
                      },
                      children: [
                        for (int index = 0; index < _taskList.length; index++)
                          Dismissible(
                            key: Key(_taskList[index]),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              _removeTask(index);
                            },
                            background: Container(
                              color: Colors.redAccent,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Icon(Icons.delete, color: Colors.white),
                                ),
                              ),
                            ),
                            child: ListTile(
                              key: ValueKey(_taskList[index]),
                              title: Text(_taskList[index], style: bodyMedium),
                              leading: Checkbox(
                                value: false,
                                onChanged: (bool? value) {
                                },
                              ),
                            ),
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
                      onTap: null,
                      child: const Padding(
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
          activeColor:Colors.green,
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
