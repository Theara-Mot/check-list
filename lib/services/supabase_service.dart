// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/task.dart';
// class SupabaseService {
//   final SupabaseClient _client;
//
//   SupabaseService()
//       : _client = SupabaseClient(
//     'https://mqnnlrfkyfuwqwvcuxwa.supabase.co',
//     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1xbm5scmZreWZ1d3F3dmN1eHdhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTgxNzA1MzcsImV4cCI6MjAzMzc0NjUzN30.jLvivS70XMMGXV2XP6syM4WnvVYgIyKqybZbaTVw540',
//   );
//
//   Stream<List<Task>> getTasksStream() {
//     return _client
//         .from('tasks')
//         .stream(['id']) // Stream all rows in the 'tasks' table
//         .order('created_at', ascending: false)
//         .execute()
//         .map((data) => data.map((e) => Task.fromJson(e)).toList());
//   }
//
//   Future<void> addTask(Task task) async {
//     final response = await _client
//         .from('tasks')
//         .insert(task.toJson())
//         .execute();
//
//     if (response.error != null) {
//       throw response.error!;
//     }
//   }
//
//   Future<void> updateTask(Task task) async {
//     final response = await _client
//         .from('tasks')
//         .update(task.toJson())
//         .eq('id', task.id)
//         .execute();
//
//     if (response.error != null) {
//       throw response.error!;
//     }
//   }
//
//   Future<void> deleteTask(String id) async {
//     final response = await _client
//         .from('tasks')
//         .delete()
//         .eq('id', id)
//         .execute();
//
//     if (response.error != null) {
//       throw response.error!;
//     }
//   }
// }
