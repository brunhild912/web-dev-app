// import 'package:flutter/material.dart';
// import '../../model/file.dart';
//
// class Editor2Screen extends StatefulWidget {
//   final List<Files> files;
//
//   const Editor2Screen({required this.files, Key? key}) : super(key: key);
//
//   @override
//   _Editor2ScreenState createState() => _Editor2ScreenState();
// }
//
// class _Editor2ScreenState extends State<Editor2Screen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final Map<String, TextEditingController> _textControllers = {};
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Debug: Check how many files are being passed
//     print("Editor2Screen - Number of files: ${widget.files.length}");
//
//     // Initialize TabController and TextEditingControllers for each file
//     _tabController = TabController(length: widget.files.length, vsync: this);
//
//     for (var file in widget.files) {
//       // Debug: Check each file's ID and content
//       print("Initializing controller for file ID: ${file.id}, Content: ${file.content}");
//
//       _textControllers[file.id] = TextEditingController(text: file.content); // Assuming `content` is the file data
//     }
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     for (var controller in _textControllers.values) {
//       controller.dispose();
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Debug: Check if build is being called
//     print("Editor2Screen - Building widget");
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Editor"),
//         bottom: TabBar(
//           controller: _tabController,
//           isScrollable: true,
//           tabs: widget.files.map((file) {
//             // Debug: Ensure each tab is being created
//             print("Creating tab for file: ${file.name}");
//             return Tab(text: file.name);
//           }).toList(),
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: widget.files.map((file) {
//           // Debug: Check each tab's content during TabBarView creation
//           print("Creating TabBarView for file ID: ${file.id}");
//           return _buildEditorTab(file);
//         }).toList(),
//       ),
//     );
//   }
//
//   Widget _buildEditorTab(Files file) {
//     // Debug: Ensure each editor tab has a controller and is associated with correct content
//     print("Building editor for file ID: ${file.id} with initial content: ${file.content}");
//
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: TextField(
//         controller: _textControllers[file.id],
//         maxLines: null,
//         decoration: InputDecoration(
//           border: OutlineInputBorder(),
//           labelText: file.name,
//         ),
//       ),
//     );
//   }
// }

import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import for Firebase
import 'package:highlight/languages/css.dart';
import 'package:provider/provider.dart';
import '../../model/file.dart';
import '../../providers/user_provider.dart';

class Editor2Screen extends StatefulWidget {
  final List<Files> files;
  final String folderId;

  const Editor2Screen({required this.files, super.key, required this.folderId});

  @override
  _Editor2ScreenState createState() => _Editor2ScreenState();
}

class _Editor2ScreenState extends State<Editor2Screen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, CodeController> _codeControllers = {};

  @override
  void initState() {
    super.initState();

    // Debug: Check how many files are being passed
    print("Editor2Screen - Number of files: ${widget.files.length}");

    // Initialize TabController and CodeControllers for each file
    _tabController = TabController(length: widget.files.length, vsync: this);

    for (var file in widget.files) {
      // Debug: Check each file's ID and content
      print(
          "Initializing controller for file ID: ${file.docId}, Content: ${file.content}");

      // Initialize CodeController for each file
      _codeControllers[file.docId] = CodeController(
        text: file.content,
        language: css,
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (var controller in _codeControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveFileContent(
      String folderId, Files file, String newContent) async {
    try {
      final userId = Provider.of<UserProvider>(context, listen: false).userId;

      if (userId.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('folders')
            .doc(folderId)
            .collection('files')
            .doc(file.docId) // Use Firestore document ID here
            .update({'content': newContent});

        // Optional: Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File '${file.name}' saved successfully!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save '${file.name}'")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Editor2Screen - Building widget");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Editor"),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: widget.files.map((file) {
            print("Creating tab for file: ${file.name}");
            return Tab(text: file.name);
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: widget.files.map((file) {
          print("Creating TabBarView for file ID: ${file.docId}");
          return _buildEditorTab(file);
        }).toList(),
      ),
    );
  }

  Widget _buildEditorTab(Files file) {
    print(
        "Building editor for file ID: ${file.docId} with initial content: ${file.content}");

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: CodeField(
              controller: _codeControllers[file.docId]!,
              textStyle: const TextStyle(fontFamily: 'SourceCodePro'),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Get the updated content from the CodeController
              final newContent = _codeControllers[file.docId]!.text;

              // Call _saveFileContent with the folderId, file, and updated content
              _saveFileContent(widget.folderId, file, newContent);
            },
            child: Text("Save ${file.name}"),
          ),
        ],
      ),
    );
  }
}
