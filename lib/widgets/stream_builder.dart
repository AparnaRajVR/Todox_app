import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:todo_app/constants/const.dart';
import 'package:todo_app/services/firebase_service.dart';
import 'package:todo_app/widgets/bottom_sheet.dart';
import 'package:todo_app/widgets/statuscard.dart';

class TaskStreamWidget extends StatelessWidget {
  const TaskStreamWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseService.gettask(),
      builder: (context, snapshot) {
        
        if (!snapshot.hasData || snapshot.data == null) {
          return SizedBox.shrink();
        }

        final tasks = snapshot.data!.docs;

        // If no tasks exist,
        if (tasks.isEmpty) {
          return Column(
            children: [
             
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatusCard(label: "Pending", count: 0),
                  StatusCard(label: "Completed", count: 0),
                ],
              ),
              Divider(),
              SizedBox(height: 30),
             
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.event_note_outlined, size: 50),
                    SizedBox(height: 10),
                    Text(
                      "You don't have any tasks yet",
                      style: TextStyle(color: textcolor, fontSize: 18),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Start adding tasks and manage your time effectively",
                      style: TextStyle(
                        color: textcolor,
                        fontSize: 16,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          );
        }

       
        int pendingCount = 0;
        int completedCount = 0;

        for (var task in tasks) {
          final taskdata = task.data() as Map<String, dynamic>?;
          if (taskdata != null) {
            if (taskdata["status"] == 'pending') {
              pendingCount++;
            } else if (taskdata["status"] == 'completed') {
              completedCount++;
            }
          }
        }

        return Column(
          children: [
            // Status Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatusCard(label: "Pending", count: pendingCount),
                StatusCard(label: "Completed", count: completedCount),
              ],
            ),

            Divider(color: textcolor[50]),
            SizedBox(height: 30),

            // Task List
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final taskdoc = tasks[index];
                  final taskdata = taskdoc.data() as Map<String, dynamic>?;
                  final taskStatus = taskdata?['status'] ?? 'pending';
                  bool ischecked = taskStatus == 'completed';

                  return Card(
                    margin: EdgeInsets.fromLTRB(8, 10, 10, 8),
                    color: boxcolor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: 16, right: 8),
                      leading: Checkbox(
                        value: ischecked,
                        onChanged: (bool? value) async {
                          if (value != null) {
                            try {
                              String newStatus =
                                  value ? 'completed' : 'pending';
                              await FirebaseService.updatetaskstatus(
                                taskdoc.id,
                                newStatus,
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to update task'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        activeColor: primary,
                        shape: CircleBorder(),
                      ),
                      title: Text(
                        taskdata?['name'] ?? 'Unnamed task',
                        style: TextStyle(
                          color: onSurface,
                          fontSize: 18,
                          decoration:
                              ischecked
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              bottomSheet(
                                context,
                                isEditing: true,
                                taskid: taskdata?['taskid'],
                                existingTask: taskdata?['name'],
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
                                  message:
                                      "Are you sure you want to delete '${taskdata?['name']}'",
                                  confirmButtonText: "Delete",
                                  cancelButtonText: "Cancel",
                                  onTapCancel: () {
                                    Navigator.pop(context);
                                  },
                                  onTapConfirm: () async {
                                    Navigator.pop(context);
                                    try {
                                      await FirebaseService.deletetask(
                                        taskdoc.id,
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Task deleted successfully",
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("failed to delete: $e"),
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
                              icon: Icon(Icons.delete_outlined, size: 17),padding: EdgeInsets.all(8),      
      splashRadius: 16,
      visualDensity: VisualDensity.compact,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
