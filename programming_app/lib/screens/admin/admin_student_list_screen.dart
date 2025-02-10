import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'admin_chat_page.dart';

class AdminStudentListScreen extends StatelessWidget {
  const AdminStudentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student List'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 17,
            )),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ));
          }

          var students = snapshot.data!.docs;

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              var student = students[index];
              return ListTile(
                title: Text(student['username']),  // Display student's name
                subtitle: Text(student['email']),  // Display student's email (optional)
                onTap: () {
                  // Navigate to the ChatScreen with the student's UID
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminChatPage(
                        studentId: student['uid'],
                        studentName: student['username'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
