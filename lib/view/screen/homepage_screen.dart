import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/constants/const.dart';
import 'package:todo_app/provider/task_provider.dart';
import 'package:todo_app/view/widgets/custom_appbar.dart';
import 'package:todo_app/view/widgets/empty_state.dart';
import 'package:todo_app/view/widgets/search_bar.dart';
import 'package:todo_app/view/widgets/search_provider.dart';
import 'package:todo_app/view/widgets/task_counter.dart';
import 'package:todo_app/view/widgets/task_list.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: CustomAppBarWidget(title: "ToDoX"),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.isLoading) {
            return Center(child: CircularProgressIndicator(color: primary));
          }
          return Column(
            children: [
              // Search bar widget
              Consumer<SearchProvider>(
                builder: (context, searchProvider, child) {
                  return SearchBarWidget(
                    onChanged: (value) {
                      searchProvider.updateSearchQuery(value);
                    },
                  );
                },
              ),
              // Task counters widget
              TaskCountersWidget(
                pendingCount:
                    taskProvider.tasks
                        .where((task) => !task.isCompleted)
                        .length,
                completedCount:
                    taskProvider.tasks.where((task) => task.isCompleted).length,
              ),
              SizedBox(height: 16),
              // Task list or empty state
              Expanded(
                child:
                    taskProvider.tasks.isEmpty
                        ? EmptyStateWidget()
                        : TaskListWidget(),
              ),
            ],
          );
        },
      ),
    );
  }
}
