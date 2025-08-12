import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/constants/const.dart';
import 'package:todo_app/services/firebase_service.dart';
import 'package:todo_app/view/widgets/statuscard.dart';
import 'package:todo_app/view/widgets/task_action_buttons.dart';

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatusCard(label: "Pending", count: pendingCount),
                StatusCard(label: "Completed", count: completedCount),
              ],
            ),

            Divider(color: textcolor[50]),
            SizedBox(height: 30),

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
                      trailing: TaskActionButtons(
                        taskId: taskdata?['taskid'] ?? taskdoc.id,
                        taskName: taskdata?['name'] ?? 'Unnamed task',
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
