import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/folder_provider.dart';
import '../../providers/user_provider.dart';
import 'file_2_screen.dart';

class Folder2Screen extends StatefulWidget {
  const Folder2Screen({super.key});

  @override
  State<Folder2Screen> createState() => _Folder2ScreenState();
}

class _Folder2ScreenState extends State<Folder2Screen> {
  @override
  void initState() {
    super.initState();

    // Initialize folders in the provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = Provider.of<UserProvider>(context, listen: false).userId;
      if (userId.isNotEmpty) {
        Provider.of<FolderProvider>(context, listen: false)
            .initializeFolders(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final folderProvider = Provider.of<FolderProvider>(context);
    final folders = folderProvider.folders;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Folders"),
      ),
      body: ListView.builder(
        itemCount: folderProvider.folders.length,
        itemBuilder: (context, index) {
          final folder = folderProvider.folders[index];
          return ListTile(
            leading: const Icon(Icons.folder),
            title: Text(folder.name),
            subtitle: Text('${folder.fileCount} files'),
            onTap: () {
              // Navigate to FileScreen, passing the folder ID
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      File2Screen(folderId: folder.id, folderName: folder.name),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFolderDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddFolderDialog(BuildContext context) {
    final folderProvider = Provider.of<FolderProvider>(context, listen: false);
    final TextEditingController folderNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Folder"),
          content: TextField(
            controller: folderNameController,
            decoration: const InputDecoration(hintText: "Folder Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                folderProvider.addFolder(context, folderNameController.text);
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
