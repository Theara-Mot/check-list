// import 'package:checklist/models/task.dart';
// import 'package:checklist/providers/theme_notifier.dart';
// import 'package:checklist/themes/build_theme.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class TaskCreationScreen extends StatefulWidget {
//   final Task? task;
//
//   const TaskCreationScreen({Key? key, this.task}) : super(key: key);
//
//   @override
//   _TaskCreationScreenState createState() => _TaskCreationScreenState();
// }
//
// class _TaskCreationScreenState extends State<TaskCreationScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   bool _isCompleted = false;
//   DateTime _selectedDate = DateTime.now();
//   stt.SpeechToText _speech = stt.SpeechToText();
//   bool _isListening = false;
//   bool _isPermissionGranted = false;
//
//   final List<String> _backgroundImages = [
//     'assets/background_images/background1.jpg',
//     'assets/background_images/background2.jpg',
//   ];
//
//   @override
//   void dispose() {
//     _speech.cancel();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.task != null) {
//       _titleController.text = widget.task!.title;
//       _descriptionController.text = widget.task!.description;
//       _isCompleted = widget.task!.isCompleted;
//       _selectedDate = widget.task!.created_at;
//     }
//     _requestPermission();
//   }
//
//   Future<void> _requestPermission() async {
//     bool permission = await _speech.initialize(
//       onError: (e) => print('Error: $e'),
//     );
//     setState(() {
//       _isPermissionGranted = permission;
//     });
//   }
//
//   Future<void> _saveTask() async {
//     final task = Task(
//       id: widget.task!.id.toString(),
//       title: _titleController.text,
//       description: _descriptionController.text,
//       isCompleted: _isCompleted,
//       created_at: _selectedDate,
//       priority: 0,
//     );
//     if (_titleController.text.isEmpty) {
//       // Show error
//     } else if (_descriptionController.text.isEmpty) {
//       // Show error
//     } else {
//       // Save task to your backend
//     }
//     Navigator.pop(context);
//   }
//
//   void _selectDate(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext builder) {
//         return Container(
//           height: MediaQuery.of(context).copyWith().size.height / 3,
//           child: Column(
//             children: [
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 20),
//                 alignment: Alignment.center,
//                 height: 40,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Select Date and Time',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     Icon(Icons.close, color: Colors.red)
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: CupertinoDatePicker(
//                   initialDateTime: _selectedDate,
//                   onDateTimeChanged: (DateTime newDate) {
//                     setState(() {
//                       _selectedDate = newDate;
//                     });
//                   },
//                   use24hFormat: false,
//                   mode: CupertinoDatePickerMode.dateAndTime,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> _listen() async {
//     if (!_isListening) {
//       bool available = await _speech.initialize(
//         onStatus: (val) => print('onStatus: $val'),
//         onError: (val) => print('onError: $val'),
//       );
//       if (available) {
//         setState(() => _isListening = true);
//         _speech.listen(
//           onResult: (val) => setState(() {
//             _titleController.text = val.recognizedWords;
//           }),
//         );
//       } else {
//         print("The user has denied the use of speech recognition.");
//       }
//     } else {
//       setState(() => _isListening = false);
//       _speech.stop();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var themeNotifier = context.read(themeNotifierProvider);
//     TextStyle textStyle = themeNotifier.themeData.textTheme.bodyText1!;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('New Task'),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage(themeNotifier.backgroundImage),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         actions: [
//           DropdownButton<String>(
//             items: _backgroundImages
//                 .map((image) => DropdownMenuItem(
//                       value: image,
//                       child: Container(
//                         width: 100,
//                         height: 20,
//                         decoration: BoxDecoration(
//                           image: DecorationImage(
//                             image: AssetImage(image),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ))
//                 .toList(),
//             onChanged: (String? newImage) {
//               if (newImage != null) {
//
//                 // themeNotifier.setTheme(newTheme, newImage);
//                 themeNotifier.setTheme(1);
//               }
//             },
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             colorFilter: ColorFilter.mode(Colors.black, BlendMode.overlay),
//             image: AssetImage(themeNotifier.backgroundImage),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: <Widget>[
//                 SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('Title', style: textStyle),
//                     Text(
//                       _speech.isListening ? 'Listening ...' : '',
//                       style: textStyle,
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Card(
//                         elevation: 0,
//                         color: Colors.white.withOpacity(0.5),
//                         margin: EdgeInsets.zero,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 3, horizontal: 12),
//                           child: TextFormField(
//                             controller: _titleController,
//                             decoration: InputDecoration(
//                               hintText: 'Enter task here',
//                               border: InputBorder.none,
//                               contentPadding: EdgeInsets.zero,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 5),
//                     GestureDetector(
//                       onTap: _listen,
//                       child: Icon(
//                         Icons.keyboard_voice_sharp,
//                         size: 30,
//                         color: Colors.blue,
//                       ),
//                     )
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 Text('Priority', style: textStyle),
//                 Card(
//                   elevation: 0,
//                   color: Colors.white.withOpacity(0.5),
//                   margin: EdgeInsets.zero,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 3, horizontal: 8),
//                     child: TextFormField(
//                       keyboardType: TextInputType.number,
//                       controller: _descriptionController,
//                       decoration: InputDecoration(
//                         hintText: 'Enter priority here',
//                         border: InputBorder.none,
//                         contentPadding: EdgeInsets.zero,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Text('Due date', style: textStyle),
//                 Card(
//                   elevation: 0,
//                   margin: EdgeInsets.zero,
//                   color: Colors.white.withOpacity(0.5),
//                   child: ListTile(
//                     title: Text(
//                       "${DateFormat('dd-MM-yyyy HH:mm a').format(_selectedDate)}",
//                       style: textStyle,
//                     ),
//                     trailing: Icon(Icons.keyboard_arrow_down),
//                     onTap: () => _selectDate(context),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Text('Background', style: textStyle),
//                 Card(
//                   elevation: 0,
//                   color: Colors.white.withOpacity(0.5),
//                   margin: EdgeInsets.zero,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 3, horizontal: 8),
//                     child: DropdownButton<String>(
//                       items: _backgroundImages
//                           .map((image) => DropdownMenuItem(
//                                 value: image,
//                                 child: Container(
//                                   width: 100,
//                                   height: 20,
//                                   decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                       image: AssetImage(image),
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                 ),
//                               ))
//                           .toList(),
//                       onChanged: (String? newImage) {
//                         if (newImage != null) {
//                           ThemeData newTheme = ThemeData(
//                             primarySwatch: Colors.blue,
//                             textTheme: TextTheme(
//                               // bodyText1: StyleConfig.backgroundTextStyles[newImage] ?? TextStyle(color: Colors.white),
//                             ),
//                           );
//                           // themeNotifier.setTheme(newTheme, newImage);
//                           themeNotifier.setTheme(1);
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(30),
//                     color: Colors.blue.withOpacity(0.8),
//                   ),
//                   child: InkWell(
//                     splashColor: Colors.blueAccent,
//                     borderRadius: BorderRadius.circular(30),
//                     onTap: _saveTask,
//                     child: const Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Center(
//                         child: Text(
//                           'Save',
//                           style: TextStyle(
//                             fontSize: 18,
//                             color: Colors.white,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
