import 'package:cloud_firestore/cloud_firestore.dart';

class Files {
  final String docId;
  final String name;
  final String content;
  final DateTime createdAt;

  Files({
    required this.docId,
    required this.name,
    required this.content,
    required this.createdAt,
  });

  // Factory method to create a Files object from Firestore data
  factory Files.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Files(
      docId: doc.id,
      name: data['name'] ?? 'Untitled',
      content: data['content'] ?? '', // Assumes there's a 'content' field in Firebase
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
