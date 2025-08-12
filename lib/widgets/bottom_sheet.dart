import 'package:flutter/material.dart';
import 'package:todo_app/constants/const.dart';
import 'package:todo_app/services/firebase_service.dart';

final TextEditingController taskcontroller = TextEditingController();

Future<dynamic> bottomSheet(BuildContext context, {
  bool isEditing = false,
  String? taskid,
  String? existingTask,
}) {
  if (isEditing && existingTask != null) {
    taskcontroller.text = existingTask;
  } else {
    taskcontroller.clear();
  }

  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.horizontal(
        left: Radius.circular(20),
        right: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              isEditing ? "Edit Task" : "Add Task",
              style: TextStyle(
                color: onSurface,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: taskcontroller,
              style: TextStyle(color: onSurface),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "Enter Task Name",
                hintStyle: TextStyle(color: textcolor),
              ),
            ),
            SizedBox(height: 20),
            Container(
              alignment: Alignment.bottomRight,
              child: IconButton(
                onPressed: () async {
                  final taskname = taskcontroller.text.trim();
                  if (taskname.isNotEmpty) {
                    try {
                      if (isEditing && taskid != null) {
                        await FirebaseService.updatetask(taskid, taskname);
                      } else {
                        await FirebaseService.storetask(taskname);
                      }
                      
                      Navigator.of(context).pop();
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isEditing ? "Task updated successfully!" : "Task added successfully!",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Failed to ${isEditing ? 'update' : 'add'} task",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  }
                },
                icon: Icon(Icons.send, color: primary),
              ),
            ),
          ],
        ),
      );
    },
  );
}