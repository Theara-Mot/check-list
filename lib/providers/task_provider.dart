import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/task.dart';
import '../services/supabase_service.dart';

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier();
});

class TaskNotifier extends StateNotifier<List<Task>> {
  final SupabaseService _supabaseService;

  TaskNotifier() : _supabaseService = SupabaseService(), super([]);

  Future<void> loadTasks() async {
    state = (await _supabaseService.getTasksStream()) as List<Task>;
  }

  Future<void> addTask(Task task) async {
    await _supabaseService.addTask(task);
    state = [...state, task];
  }

  Future<void> updateTask(Task task) async {
    await _supabaseService.updateTask(task);
    state = [
      for (final t in state)
        if (t.id == task.id) task else t,
    ];
  }

  Future<void> deleteTask(String id) async {
    await _supabaseService.deleteTask(id);
    state = state.where((task) => task.id != id).toList();
  }
}
