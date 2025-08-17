// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:todo_app/constants/const.dart';
// import 'package:todo_app/services/firebase_service.dart';
// import 'package:todo_app/view/widgets/statuscard.dart';
// import 'package:todo_app/view/widgets/task_action_buttons.dart';

// class TaskStreamWidget extends StatelessWidget {
//   const TaskStreamWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseService.gettask(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData || snapshot.data == null) {
//           return SizedBox.shrink();
//         }

//         final tasks = snapshot.data!.docs;

//         if (tasks.isEmpty) {
//           return Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   StatusCard(label: "Pending", count: 0),
//                   StatusCard(label: "Completed", count: 0),
//                 ],
//               ),
//               Divider(),
//               SizedBox(height: 30),
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Icon(Icons.event_note_outlined, size: 50),
//                     SizedBox(height: 10),
//                     Text(
//                       "You don't have any tasks yet",
//                       style: TextStyle(color: textcolor, fontSize: 18),
//                     ),
//                     SizedBox(height: 5),
//                     Text(
//                       "Start adding tasks and manage your time effectively",
//                       style: TextStyle(
//                         color: textcolor,
//                         fontSize: 16,
//                         height: 1.5,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         }

//         int pendingCount = 0;
//         int completedCount = 0;

//         for (var task in tasks) {
//           final taskdata = task.data() as Map<String, dynamic>?;
//           if (taskdata != null) {
//             if (taskdata["status"] == 'pending') {
//               pendingCount++;
//             } else if (taskdata["status"] == 'completed') {
//               completedCount++;
//             }
//           }
//         }

//         return Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 StatusCard(label: "Pending", count: pendingCount),
//                 StatusCard(label: "Completed", count: completedCount),
//               ],
//             ),

//             Divider(color: textcolor[50]),
//             SizedBox(height: 30),

//             Expanded(
//               child: ListView.builder(
//                 itemCount: tasks.length,
//                 itemBuilder: (context, index) {
//                   final taskdoc = tasks[index];
//                   final taskdata = taskdoc.data() as Map<String, dynamic>?;
//                   final taskStatus = taskdata?['status'] ?? 'pending';
//                   bool ischecked = taskStatus == 'completed';

//                   return Card(
//                     margin: EdgeInsets.fromLTRB(8, 10, 10, 8),
//                     color: boxcolor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: ListTile(
//                       contentPadding: EdgeInsets.only(left: 16, right: 8),
//                       leading: Checkbox(
//                         value: ischecked,
//                         onChanged: (bool? value) async {
//                           if (value != null) {
//                             try {
//                               String newStatus =
//                                   value ? 'completed' : 'pending';
//                               await FirebaseService.updatetaskstatus(
//                                 taskdoc.id,
//                                 newStatus,
//                               );
//                             } catch (e) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text('Failed to update task'),
//                                   backgroundColor: Colors.red,
//                                 ),
//                               );
//                             }
//                           }
//                         },
//                         activeColor: primary,
//                         shape: CircleBorder(),
//                       ),
//                       title: Text(
//                         taskdata?['name'] ?? 'Unnamed task',
//                         style: TextStyle(
//                           color: onSurface,
//                           fontSize: 18,
//                           decoration:
//                               ischecked
//                                   ? TextDecoration.lineThrough
//                                   : TextDecoration.none,
//                         ),
//                       ),
//                       trailing: TaskActionButtons(
//                         taskId: taskdata?['taskid'] ?? taskdoc.id,
//                         taskName: taskdata?['name'] ?? 'Unnamed task',
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/constants/const.dart';
import 'package:todo_app/services/firebase_service.dart';
import 'package:todo_app/view/widgets/statuscard.dart';
import 'package:todo_app/view/widgets/task_action_buttons.dart';

class TaskStreamWidget extends StatelessWidget {
  final String searchQuery;
  
  const TaskStreamWidget({
    super.key,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    // Use async search if search query is provided, otherwise use regular stream
    if (searchQuery.trim().isNotEmpty) {
      return _buildAsyncSearchWidget();
    } else {
      return _buildStreamWidget();
    }
  }

  // Async search widget for reliable search results
  Widget _buildAsyncSearchWidget() {
    return FutureBuilder<List<QueryDocumentSnapshot>>(
      future: FirebaseService.searchTasks(searchQuery),
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: primary),
                SizedBox(height: 16),
                Text("Searching for '$searchQuery'...", style: TextStyle(color: textcolor)),
              ],
            ),
          );
        }

        // Error state
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 50),
                SizedBox(height: 16),
                Text("Error searching tasks", style: TextStyle(color: textcolor, fontSize: 18)),
              ],
            ),
          );
        }

        // No data
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(
            child: Text("No search results", style: TextStyle(color: textcolor)),
          );
        }

        final tasks = snapshot.data!;

        // Empty state
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
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 50, color: textcolor),
                      SizedBox(height: 16),
                      Text("No tasks found for '$searchQuery'", style: TextStyle(color: textcolor, fontSize: 18)),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

                 // Search results with status cards
         return Column(
           children: [
             // Status cards
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 StatusCard(label: "Pending", count: tasks.where((t) => (t.data() as Map<String, dynamic>?)?['status'] == 'pending').length),
                 StatusCard(label: "Completed", count: tasks.where((t) => (t.data() as Map<String, dynamic>?)?['status'] == 'completed').length),
               ],
             ),
             
             Divider(color: textcolor[50]),
             SizedBox(height: 20),
             
             // Task list
             Expanded(child: _buildTaskListOnly(tasks)),
           ],
         );
      },
    );
  }

  // Stream widget for regular task display (non-search)
  Widget _buildStreamWidget() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseService.gettask(),
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: primary),
                SizedBox(height: 16),
                Text("Loading tasks...", style: TextStyle(color: textcolor)),
              ],
            ),
          );
        }

        // Error state
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 50),
                SizedBox(height: 16),
                Text("Error loading tasks", style: TextStyle(color: textcolor, fontSize: 18)),
              ],
            ),
          );
        }

        // No data
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(
            child: Text("No tasks available", style: TextStyle(color: textcolor)),
          );
        }

        final tasks = snapshot.data!.docs;

        // Empty state
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
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_note_outlined, size: 50, color: textcolor),
                      SizedBox(height: 16),
                      Text("You don't have any tasks yet", style: TextStyle(color: textcolor, fontSize: 18)),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return _buildTaskList(tasks);
      },
    );
  }

  // Common method to build task list UI with status cards
  Widget _buildTaskList(List<QueryDocumentSnapshot> tasks) {
    return Column(
      children: [
        // Status cards
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StatusCard(label: "Pending", count: tasks.where((t) => (t.data() as Map<String, dynamic>?)?['status'] == 'pending').length),
            StatusCard(label: "Completed", count: tasks.where((t) => (t.data() as Map<String, dynamic>?)?['status'] == 'completed').length),
          ],
        ),
        
        Divider(color: textcolor[50]),
        SizedBox(height: 20),
        
        // Task list
        Expanded(child: _buildTaskListOnly(tasks)),
      ],
    );
  }

  // Method to build only the task list (without status cards)
  Widget _buildTaskListOnly(List<QueryDocumentSnapshot> tasks) {
    return ListView.builder(
      itemCount: tasks.length,
      padding: EdgeInsets.only(bottom: 20),
      itemBuilder: (context, index) {
        final task = tasks[index];
        final taskData = task.data() as Map<String, dynamic>;
        final isChecked = taskData['status'] == 'completed';
        
        return Card(
          margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
          color: boxcolor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: EdgeInsets.only(left: 16, right: 8),
            leading: Checkbox(
              value: isChecked,
              onChanged: (value) async {
                if (value != null) {
                  try {
                    await FirebaseService.updatetaskstatus(
                      task.id,
                      value ? 'completed' : 'pending',
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update task'), backgroundColor: Colors.red),
                    );
                  }
                }
              },
              activeColor: primary,
              shape: CircleBorder(),
            ),
            title: Text(
              taskData['name'] ?? 'Unnamed task',
              style: TextStyle(
                color: onSurface,
                fontSize: 18,
                decoration: isChecked ? TextDecoration.lineThrough : TextDecoration.none,
              ),
            ),
            trailing: TaskActionButtons(
              taskId: taskData['taskid'] ?? task.id,
              taskName: taskData['name'] ?? 'Unnamed task',
            ),
          ),
        );
      },
    );
  }
}
