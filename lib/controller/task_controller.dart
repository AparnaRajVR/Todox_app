import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
 
  static Future<void> storetask(String taskname, {
    String? description,
    DateTime? dueDate,
   
  }) async {
    final collection = FirebaseFirestore.instance.collection("Dailytask");
    final docRef = collection.doc();
    
    Map<String, dynamic> taskData = {
      "taskid": docRef.id,
      "name": taskname,
      "status": "pending",
      "createdAt": FieldValue.serverTimestamp(),
    };
    
    // Add optional fields if provided
    if (description != null && description.isNotEmpty) {
      taskData["description"] = description;
    }
    
    if (dueDate != null) {
      taskData["dueDate"] = Timestamp.fromDate(dueDate);
    }
    
    await docRef.set(taskData);
    print("Task saved: $taskname with ID: ${docRef.id}"); 
  }

  static Stream<QuerySnapshot> gettask() {
    return FirebaseFirestore.instance
        .collection("Dailytask")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

 
  static Future<List<QueryDocumentSnapshot>> searchTasksAsync(String searchQuery) async {
    if (searchQuery.trim().isEmpty) {
      // If search query is empty, return all tasks
      final snapshot = await FirebaseFirestore.instance
          .collection("Dailytask")
          .orderBy("createdAt", descending: true)
          .get();
      return snapshot.docs;
    }
    
    try {
      // Get all tasks and filter locally 
      final snapshot = await FirebaseFirestore.instance
          .collection("Dailytask")
          .orderBy("createdAt", descending: true)
          .get();
      
      // Filter tasks locally for substring search
      String query = searchQuery.trim().toLowerCase();
      List<QueryDocumentSnapshot> filteredTasks = snapshot.docs.where((doc) {
        final taskData = doc.data() as Map<String, dynamic>?;
        if (taskData != null && taskData['name'] != null) {
          String taskName = taskData['name'].toString().toLowerCase();
          String taskDescription = taskData['description']?.toString().toLowerCase() ?? '';
          return taskName.contains(query) || taskDescription.contains(query); // Search in both name and description
        }
        return false;
      }).toList();
      
      return filteredTasks;
    } catch (e) {
      
      
      final snapshot = await FirebaseFirestore.instance
          .collection("Dailytask")
          .orderBy("createdAt", descending: true)
          .get();
      return snapshot.docs;
    }
  }

  static Future<void> updatetaskstatus(String taskid, String newstatus) async {
    try {
      await FirebaseFirestore.instance
          .collection("Dailytask")
          .doc(taskid)
          .update({'status': newstatus});
      print("Task status updated: $taskid -> $newstatus"); 
    } catch (e) {
      throw Exception("Failed to update:$e");
    }
  }

  static Future<void> deletetask(String taskid) async {
    try {
      await FirebaseFirestore.instance
          .collection("Dailytask")
          .doc(taskid)
          .delete();
      print("Task deleted: $taskid"); 
    } catch (e) {
      throw Exception("Failed to Delete :$e");
    }
  }

  static Future<void> updatetask(String taskid, String newtask) async {
    try {
      await FirebaseFirestore.instance
          .collection("Dailytask")
          .doc(taskid)
          .update({'name': newtask});
      print("Task name updated: $taskid -> $newtask"); 
    } catch (e) {
      throw Exception("Failed to update :$e");
    }
  }

  // Update task with all attributes
  static Future<void> updateTaskComplete(String taskid, {
    String? name,
    String? description,
    DateTime? dueDate,
    String? priority,
    String? status,
  }) async {
    try {
      Map<String, dynamic> updateData = {};
      
      if (name != null) updateData['name'] = name;
      if (description != null) updateData['description'] = description;
      if (dueDate != null) updateData['dueDate'] = Timestamp.fromDate(dueDate);
      if (priority != null) updateData['priority'] = priority;
      if (status != null) updateData['status'] = status;
      
      await FirebaseFirestore.instance
          .collection("Dailytask")
          .doc(taskid)
          .update(updateData);
      
      print("Task updated: $taskid with data: $updateData"); 
    } catch (e) {
      throw Exception("Failed to update task: $e");
    }
  }
}
