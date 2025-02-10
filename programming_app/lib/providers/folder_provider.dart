import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/folder.dart';
import '../providers/user_provider.dart';
import 'package:provider/provider.dart';

class FolderProvider extends ChangeNotifier {
  List<Folder> _folders = [];

  List<Folder> get folders => _folders;


  void initializeFolders(String userId) {
    if (userId.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('folders')
          .snapshots()
          .listen((snapshot) {
        _folders = snapshot.docs.map((doc) => Folder.fromDocument(doc)).toList();
        notifyListeners();
      });
    }
  }

  Future<void> addFolder(BuildContext context, String name) async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;

    if (userId.isNotEmpty) {
      final folderRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('folders')
          .doc();
      await folderRef.set({
        'name': name,
        'fileCount': 0,
      });
    }
  }

  Future<void> updateFileCount(BuildContext context, String folderId, int newFileCount) async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;

    if (userId.isNotEmpty) {
      final folderRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('folders')
          .doc(folderId);
      await folderRef.update({
        'fileCount': newFileCount,
      });
    }
  }
}
