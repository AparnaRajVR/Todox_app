import 'package:flutter/material.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:todo_app/services/firebase_service.dart';
import 'package:todo_app/view/widgets/bottom_sheet.dart';

class TaskActionButtons extends StatelessWidget {
  final String taskId;
  final String taskName;

  const TaskActionButtons({
    Key? key,
    required this.taskId,
    required this.taskName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            bottomSheet(
              context,
              isEditing: true,
              taskid: taskId,
              existingTask: taskName,
            );
          },
          icon: Icon(Icons.edit_outlined, size: 17),
          padding: EdgeInsets.all(8),
          constraints: BoxConstraints(),
          splashRadius: 16,
          visualDensity: VisualDensity.compact,
        ),
        Transform.translate(
          offset: Offset(-15, 0),
          child: IconButton(
            onPressed: () {
              PanaraConfirmDialog.show(
                context,
                title: "Delete Task",
                message: "Are you sure you want to delete '$taskName'",
                confirmButtonText: "Delete",
                cancelButtonText: "Cancel",
                onTapCancel: () {
                  Navigator.pop(context);
                },
                onTapConfirm: () async {
                  Navigator.pop(context);
                  try {
                    await FirebaseService.deletetask(taskId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Task deleted successfully"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Failed to delete: $e"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                imagePath: 'assets/images/delete_img.png',
                panaraDialogType: PanaraDialogType.normal,
                barrierDismissible: false,
              );
            },
            icon: Icon(Icons.delete_outlined, size: 17),
            padding: EdgeInsets.all(8),
            splashRadius: 16,
            visualDensity: VisualDensity.compact,
          ),
        ),
      ],
    );
  }
}