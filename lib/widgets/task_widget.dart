// import 'package:checklist/cost/color.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // Add intl package for date formatting
// import '../models/task.dart';
//
// class TaskWidget extends StatelessWidget {
//   final Task task;
//
//   TaskWidget({required this.task});
//
//   String formatDate(DateTime date) {
//     final now = DateTime.now();
//     final tomorrow = DateTime(now.year, now.month, now.day + 1);
//
//     if (date.year == now.year && date.month == now.month && date.day == now.day) {
//       return 'Today';
//     } else if (date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day) {
//       return 'Tomorrow';
//     } else {
//       return DateFormat('dd-MM-yyyy').format(date);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Ink(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: InkWell(
//           borderRadius: BorderRadius.circular(10),
//           onTap: () {
//             // Implement navigation or other logic
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       task.title,
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: AppColors.appbar,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 3),
//                     Text(
//                       formatDate(task.created_at), // Use the formatted date here
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Checkbox(
//                   value: task.isCompleted,
//                   onChanged: (newValue) {
//                     // Implement logic to mark task as completed
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
