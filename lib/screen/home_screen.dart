import 'package:checklist/cost/color.dart';
import 'package:checklist/models/task.dart';
import 'package:checklist/screen/task_screen.dart';
import 'package:checklist/widgets/build_appbar.dart';
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../widgets/task_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SupabaseService supabaseService = SupabaseService();

  @override
  Widget build(BuildContext context) {
    return BuildAppBar(
      title: 'Check List',
      actions: [
        GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.notes_outlined, color: Colors.white, size: 28),
          ),
        ),
      ],
      body: StreamBuilder<List<Task>>(
        stream: supabaseService.getTasksStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tasks available'));
          }

          final data = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.only(top: 12, left: 8, right: 8),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final task = data[index];
              return TaskWidget(task: task);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.appbar,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskCreationScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
