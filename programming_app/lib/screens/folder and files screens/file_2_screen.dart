import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/file.dart';
import '../../providers/file_provider.dart';
import '../../providers/user_provider.dart';
import '../editor screens/editor_2_screen.dart';

class File2Screen extends StatelessWidget {
  final String folderId;
  final String folderName;

  const File2Screen(
      {required this.folderId, required this.folderName, super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final fileProvider = Provider.of<FileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(folderName),
      ),
      body: StreamBuilder<List<Files>>(
        stream: fileProvider.getFileStream(context, folderId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Debug: Check if data is retrieved
          if (!snapshot.hasData) {
            print("No data in snapshot.");
            return const Center(child: Text("No files found."));
          }

          if (snapshot.hasData) {
            print("Files retrieved: ${snapshot.data!.length}");
          }

          // Use the setFiles method to update fileProvider's _files list
          fileProvider.setFiles(snapshot.data ?? []);

          if (snapshot.data!.isEmpty) {
            return Center(child: _addNewFileTile(context, fileProvider));
          }

          final files = snapshot.data!;
          return ListView.builder(
            itemCount: files.length + 1,
            itemBuilder: (context, index) {
              if (index == files.length) {
                return _addNewFileTile(context, fileProvider);
              }

              final file = files[index];
              return ListTile(
                title: Text(file.name),
                subtitle: Text(file.createdAt.toString()),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openEditorScreen(context, fileProvider.files);
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  void _openEditorScreen(BuildContext context, List<Files> files) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Editor2Screen(
          files: files,
          folderId: folderId,
        ),
      ),
    );
  }

  Widget _addNewFileTile(BuildContext context, FileProvider fileProvider) {
    return ListTile(
      leading: const Icon(Icons.add),
      title: const Text('Add a New File'),
      onTap: () {
        showAddFileDialog(context, folderId, fileProvider);
      },
    );
  }

  Future<void> showAddFileDialog(
      BuildContext context, String folderId, FileProvider fileProvider) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final fileNameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New File'),
          content: TextField(
            controller: fileNameController,
            decoration: const InputDecoration(hintText: "Enter file name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final fileName = fileNameController.text.trim();
                if (fileName.isNotEmpty) {
                  final fileId = FirebaseFirestore.instance
                      .collection('users')
                      .doc(userProvider.userId)
                      .collection('folders')
                      .doc(folderId)
                      .collection('files')
                      .doc()
                      .id;
                  final fileData = {
                    'id': fileId,
                    'name': fileName,
                    'createdAt': Timestamp.fromDate(DateTime.now()),
                    'content': 'Hello am file content',
                  };
                  await fileProvider.addFile(context, folderId, fileData);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
