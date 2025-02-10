import 'package:cloud_firestore/cloud_firestore.dart';

class Folder {
  final String id;
  final String name;
  final int fileCount;

  Folder({
    required this.id,
    required this.name,
    this.fileCount = 0,
  });

  // Factory constructor to create Folder from Firebase document
  factory Folder.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Folder(
      id: doc.id,
      name: data['name'] ?? '',
      fileCount: data['fileCount'] ?? 0,
    );
  }

  // Convert Folder instance to Map for Firebase storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'fileCount': fileCount,
    };
  }
}
