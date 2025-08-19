import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/task_provider.dart';
import 'package:todo_app/view/widgets/search_provider.dart';
import 'package:todo_app/view/widgets/task_card.dart';

class TaskListWidget extends StatelessWidget {
  const TaskListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return Consumer<SearchProvider>(
          builder: (context, searchProvider, child) {
            final filteredTasks = taskProvider.tasks.where((task) {
              return searchProvider.searchQuery.isEmpty ||
                     task.title.toLowerCase().contains(searchProvider.searchQuery) ||
                     (task.description?.toLowerCase().contains(searchProvider.searchQuery) ?? false);
            }).toList();

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return TaskCardWidget(task: task);
              },
            );
          },
        );
      },
    );
  }
}
