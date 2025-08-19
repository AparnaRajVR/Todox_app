import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.isCompleted,
  });

  factory Task.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['name'] ?? '',
      description: data['description'],
      dueDate: data['dueDate'] != null 
          ? (data['dueDate'] as Timestamp).toDate()
          : DateTime.now(),
      isCompleted: data['status'] == 'completed',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'status': isCompleted ? 'completed' : 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  // Get tasks from Firestore
  void loadTasks() {
    _isLoading = true;
    notifyListeners();

    FirebaseFirestore.instance
        .collection('Dailytask')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _tasks = snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
      _isLoading = false;
      notifyListeners();
    });
  }

  // Add new task
  Future<void> addTask(String title, String? description, DateTime dueDate) async {
    try {
      await FirebaseFirestore.instance.collection('Dailytask').add({
        'name': title,
        'description': description,
        'dueDate': Timestamp.fromDate(dueDate),
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add task: $e');
    }
  }

  // Update task
  Future<void> updateTask(String id, String title, String? description, DateTime dueDate) async {
    try {
      await FirebaseFirestore.instance.collection('Dailytask').doc(id).update({
        'name': title,
        'description': description,
        'dueDate': Timestamp.fromDate(dueDate),
      });
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  // Delete task
  Future<void> deleteTask(String id) async {
    try {
      await FirebaseFirestore.instance.collection('Dailytask').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  // Toggle task completion
  Future<void> toggleTaskCompletion(String id) async {
    try {
      Task task = _tasks.firstWhere((t) => t.id == id);
      await FirebaseFirestore.instance.collection('Dailytask').doc(id).update({
        'status': task.isCompleted ? 'pending' : 'completed',
      });
    } catch (e) {
      throw Exception('Failed to toggle task: $e');
    }
  }
}
