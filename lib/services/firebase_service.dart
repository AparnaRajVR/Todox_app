import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static Future<void> storetask(String taskname) async {
    final collection = FirebaseFirestore.instance.collection("Dailytask");
    final docRef = collection.doc();
    await docRef.set({
      "taskid": docRef.id,
      "name": taskname,
      "status": "pending",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  static Stream<QuerySnapshot> gettask() {
    return FirebaseFirestore.instance
        .collection("Dailytask")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  static Future<void> updatetaskstatus(String taskid, String newstatus) async {
    try {
      await FirebaseFirestore.instance
          .collection("Dailytask")
          .doc(taskid)
          .update({'status': newstatus});
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
    } catch (e) {
      throw Exception("Failed to update :$e");
    }
  }

    //  search method
  static Future<List<QueryDocumentSnapshot>> searchTasks(String searchQuery) async {
    if (searchQuery.trim().isEmpty) {
      // If search query is empty, return all tasks
      final snapshot = await FirebaseFirestore.instance
          .collection("Dailytask")
          .orderBy("createdAt", descending: true)
          .get();
      return snapshot.docs;
    }
    
    try {
      
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
          return taskName.contains(query); 
        }
        return false;
      }).toList();
      
      return filteredTasks;
    } catch (e) {
      // Fallback to regular query if search fails
      print("Search fallback: $e");
      final snapshot = await FirebaseFirestore.instance
          .collection("Dailytask")
          .orderBy("createdAt", descending: true)
          .get();
      return snapshot.docs;
    }
  }

  
}
