import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:programming_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../model/file.dart';
import 'folder_provider.dart';

class FileProvider extends ChangeNotifier {
  List<Files> _files = []; // Updated to hold File objects

  List<Files> get files => _files;

  // Method to update the list of files
  void setFiles(List<Files> files) {
    _files = files;
    notifyListeners(); // Notify listeners when the list is updated
  }



  Future<void> addFile(BuildContext context, String folderId, Map<String, dynamic> fileData) async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;

    if (userId.isNotEmpty) {
      final folderRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('folders')
          .doc(folderId);

      // Step 1: Add the file to Firebase
      await folderRef.collection('files').add(fileData);

      // Step 2: Fetch the current file count
      final folderSnapshot = await folderRef.get();
      int currentFileCount = folderSnapshot['fileCount'] ?? 0;

      // Step 3: Increment the file count and update
      final newFileCount = currentFileCount + 1;
      await Provider.of<FolderProvider>(context, listen: false)
          .updateFileCount(context, folderId, newFileCount);
    }
  }

  Stream<List<Files>> getFileStream(BuildContext context, String folderId) {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;

    if (userId.isNotEmpty) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('folders')
          .doc(folderId)
          .collection('files')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return Files.fromFirestore(doc);
        }).toList();
      });
    } else {
      return Stream.value([]);
    }
  }

}
