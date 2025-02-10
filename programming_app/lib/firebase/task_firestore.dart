import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/task.dart';

class TaskFirestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAdminTask(Task task) async {
    try {
      await _firestore.collection('tasks').doc(task.id).set({
        'heading': task.heading,
        'description': task.description,
        'dateAssigned': task.dateAssigned,
        'deadline': task.deadline,
        'isDone': task.isDone,
        'id': task.id,
      });
      print("Task added successfully.");
    } catch (e) {
      print("Error adding task: $e");
    }
  }

  Future<void> addStudentTask(Task task, String userId) async {
    try {
      // Use 'add' to create a new document with an auto-generated ID
      DocumentReference taskRef = await _firestore.collection('users').doc(userId).collection('tasks').add({
        'heading': task.heading,
        'description': task.description,
        'dateAssigned': task.dateAssigned,
        'deadline': task.deadline,
        'isDone': task.isDone,
        // No need to add 'id' since Firestore will generate it
      });

      // Optionally, you can update the task with its generated ID
      await taskRef.update({'id': taskRef.id}); // Store the generated ID in the document

      print("Task added successfully to students collection with ID: ${taskRef.id}.");
    } catch (e) {
      print("Error adding task: $e");
    }
  }

  Future<List<String>> getAllUserIds() async {
    List<String> userIds = [];
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      for (var doc in querySnapshot.docs) {
        userIds.add(doc.id);
      }
    } catch (e) {
      print("Error fetching user IDs: $e");
    }
    return userIds;
  }
}
