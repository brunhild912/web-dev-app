import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:programming_app/components/helper_widgets.dart';
import 'package:programming_app/firebase/task_firestore.dart';
import 'package:programming_app/screens/admin/admin_student_list_screen.dart';
import 'package:uuid/uuid.dart';

import '../../model/task.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            logout(context);
          },
          icon: const Icon(Icons.logout),
        ),
        title: Text(
          'Admin Dashboard',
          style: theme.textTheme.titleLarge,
        ),
        actions: [
          //show notifications
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminStudentListScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.message_outlined,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('You can now assign tasks to students, tada!'),
              );
            }

            // Display the tasks in a ListView
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var taskData = snapshot.data!.docs[index];
                var task = Task(
                  heading: taskData['heading'],
                  description: taskData['description'],
                  dateAssigned: taskData['dateAssigned'],
                  deadline: taskData['deadline'],
                  isDone: taskData['isDone'],
                  id: taskData['id'],
                );

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      task.heading,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: theme.primaryColor,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        addVerticalSpace(20),
                        Text(
                          'Description: ',
                          style: theme.textTheme.bodyLarge,
                        ),
                        Text(task.description),
                        addVerticalSpace(10),
                        Text(
                          'Assigned: ',
                          style: theme.textTheme.bodyLarge,
                        ),
                        Text(task.dateAssigned),
                        addVerticalSpace(10),
                        Text(
                          'Deadline: ',
                          style: theme.textTheme.bodyLarge,
                        ),
                        Text(task.deadline),
                        addVerticalSpace(10),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: theme.primaryColor,
        onPressed: () {
          showAddTaskBottomSheet(context);
        },
        label: const Text('Add Task'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void showAddTaskBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final taskFirestore = TaskFirestore();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        TextEditingController headlineController = TextEditingController();
        TextEditingController descriptionController = TextEditingController();
        TextEditingController assignedDateController = TextEditingController();
        TextEditingController deadlineDateController = TextEditingController();

        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addVerticalSpace(16),
              _buildCustomTextField(
                controller: headlineController,
                labelText: 'Headline',
                theme: theme,
                icon: Icons.title,
              ),
              addVerticalSpace(10),
              _buildCustomTextField(
                controller: descriptionController,
                labelText: 'Description',
                theme: theme,
                icon: Icons.description,
                maxLines: 3,
              ),
              addVerticalSpace(10),
              _buildCustomTextField(
                controller: assignedDateController,
                labelText: 'Date Assigned (DD-MM-YYYY)',
                theme: theme,
                icon: Icons.date_range,
              ),
              addVerticalSpace(10),
              _buildCustomTextField(
                controller: deadlineDateController,
                labelText: 'Deadline Date (DD-MM-YYYY)',
                theme: theme,
                icon: Icons.calendar_today,
              ),
              addVerticalSpace(20),
              ElevatedButton(
                onPressed: () async {
                  final id = const Uuid().v4();
                  // Create a Task object
                  Task newTask = Task(
                    heading: headlineController.text,
                    description: descriptionController.text,
                    dateAssigned: assignedDateController.text,
                    deadline: deadlineDateController.text,
                    id: id,
                  );

                  // Add task to Firestore
                  await taskFirestore.addAdminTask(newTask);

                  // Fetch all user IDs and assign the task to each user
                  List<String> userIds = await taskFirestore.getAllUserIds();
                  for (String userId in userIds) {
                    await taskFirestore.addStudentTask(newTask, userId);
                  }

                  Navigator.pop(context); // Close the modal
                },
                child: const Text('Add Task'),
              ),
            ],
          ),
        );
      },
    );
  }

  void logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to the login screen after signing out
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print("Error logging out: $e");
      // Show an error message or handle the error appropriately
    }
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String labelText,
    required ThemeData theme,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.primaryColor, width: 2.0),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.cardColor, width: 1.0),
        ),
        prefixIcon: Icon(icon, size: 20),
        labelText: labelText,
        labelStyle: theme.textTheme.labelSmall?.copyWith(fontSize: 16),
      ),
    );
  }
}
