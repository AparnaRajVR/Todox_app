import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final bool isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.isCompleted,
  });

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TaskModel(
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
