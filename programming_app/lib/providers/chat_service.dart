import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:programming_app/providers/user_provider.dart';

class ChatService {
  final UserProvider userProvider = UserProvider();
  //get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String adminId = 'fQocBFZRgrg1G30hxkrtik7K7CV2';

  // Get current user ID (student)
  String get currentUserId => userProvider.userId;

  Future<DocumentReference> createChatRoom(String studentId) async {
    // Create a unique chatRoomId based on student and admin IDs
    String chatRoomId = getChatRoomId(studentId, adminId);

    // Check if the chat room exists, if not, create it
    DocumentReference chatRoom = _firestore.collection('chats').doc(chatRoomId);

    final chatRoomSnapshot = await chatRoom.get();
    if (!chatRoomSnapshot.exists) {
      // If chat room doesn't exist, create it
      await chatRoom.set({
        'userId': studentId, // Storing the student's ID in the chat room
        'adminId': adminId, // Storing the admin's ID in the chat room
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    return chatRoom;
  }

  // Function to create a unique chat room ID
  String getChatRoomId(String studentId, String adminId) {
    // Concatenate user IDs in a specific order to maintain consistency
    if (studentId.hashCode <= adminId.hashCode) {
      return '${studentId}_$adminId';
    } else {
      return '${adminId}_$studentId';
    }
  }

  // Send a message in the chat room
  Future<void> sendMessage(String chatRoomId, String message) async {
    // Get the chat room document reference
    DocumentReference chatRoom = _firestore.collection('chats').doc(chatRoomId);

    // Add the message to the messages subcollection
    await chatRoom.collection('messages').add({
      'text': message,
      'senderId': currentUserId, // Sender's ID (student or admin)
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Stream to listen to chat messages in real-time
  Stream<QuerySnapshot> getChatMessages(String chatRoomId) {
    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
