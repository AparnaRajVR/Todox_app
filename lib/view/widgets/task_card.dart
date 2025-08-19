import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/constants/const.dart';
import 'package:todo_app/provider/task_provider.dart';
import 'package:todo_app/view/widgets/add_task.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

class TaskCardWidget extends StatelessWidget {
  final Task task;

  const TaskCardWidget({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: boxcolor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Rounded checkbox
          GestureDetector(
            onTap: () {
              taskProvider.toggleTaskCompletion(task.id);
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: task.isCompleted ? primary : Colors.transparent,
                border: Border.all(
                  color: task.isCompleted ? primary : textcolor,
                  width: 2,
                ),
                shape: BoxShape.circle,
              ),
              child: task.isCompleted
                  ? Icon(Icons.check, color: onSurface, size: 16)
                  : null,
            ),
          ),
          SizedBox(width: 12),
          // Task content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  task.title,
                  style: TextStyle(
                    color: onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    decoration: task.isCompleted 
                        ? TextDecoration.lineThrough 
                        : TextDecoration.none,
                  ),
                ),
                // Description (if available)
                if (task.description != null && task.description!.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      task.description!,
                      style: TextStyle(
                        color: textcolor,
                        fontSize: 14,
                        decoration: task.isCompleted 
                            ? TextDecoration.lineThrough 
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                // Due date
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    'Due: ${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
                    style: TextStyle(
                      color: textcolor,
                      fontSize: 12,
                      decoration: task.isCompleted 
                          ? TextDecoration.lineThrough 
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Action buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTaskView(
                        isEditing: true,
                        task: task,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.edit, color: textcolor, size: 20),
              ),
              IconButton(
                onPressed: () {
                  PanaraConfirmDialog.show(
                    context,
                    color: primary,
                    
                    title: "Delete Task",
                    message: "Are you sure you want to delete this task?",
                    confirmButtonText: "Delete",
                    cancelButtonText: "Cancel",
                    onTapCancel: () {
                      Navigator.pop(context);
                    },
                    onTapConfirm: () async {
                      Navigator.pop(context);
                      try {
                        
                        await taskProvider.deleteTask(task.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Task deleted successfully'),
                              backgroundColor: primary,
                            ),
                          );
                        }
                      } catch (e) {
                        log('Delete error: $e'); 
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to delete task: $e'),
                              backgroundColor: primary,
                            ),
                          );
                        }
                      }
                    },
                    panaraDialogType: PanaraDialogType.error,
                    barrierDismissible: false,
                    imagePath: 'assets/images/delete_img.png',
                  );
                },
                icon: Icon(Icons.delete, color: textcolor, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
