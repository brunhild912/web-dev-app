import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:programming_app/components/helper_widgets.dart';

import '../components/my_textfield.dart';
import '../providers/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String studentId;

  const ChatPage({super.key, required this.studentId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();
  String? chatRoomId;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    createOrGetChatRoom();
    currentUserId = FirebaseAuth.instance.currentUser?.uid;
  }

  void createOrGetChatRoom() async {
    DocumentReference chatRoom =
        await _chatService.createChatRoom(widget.studentId);
    setState(() {
      chatRoomId = chatRoom.id;
    });
  }

  void sendMessage() {
    if (_messageController.text.isNotEmpty && chatRoomId != null) {
      _chatService.sendMessage(chatRoomId!, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat with Admin',
          style: theme.textTheme.displayLarge,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 17,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: chatRoomId == null
                ? Center(
                    child: CircularProgressIndicator(
                    color: theme.primaryColor,
                  ))
                : StreamBuilder<QuerySnapshot>(
                    stream: _chatService.getChatMessages(chatRoomId!),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator(
                          color: theme.primaryColor,
                        );
                      }

                      var messages = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          var message = messages[index]['text'];
                          String? senderId = messages[index]['senderId'];

                          bool isCurrentUser = senderId == currentUserId;

                          return Align(
                            alignment: isCurrentUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: isCurrentUser
                                    ? theme.primaryColor.withOpacity(0.5)
                                    : theme.cardColor.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message, // Message text
                                    style: TextStyle(
                                        color: isCurrentUser
                                            ? theme.textTheme.bodyMedium?.color
                                            : theme
                                                .textTheme.labelSmall?.color),
                                  ),
                                  addVerticalSpace(5),
                                  Text(
                                    isCurrentUser ? 'You' : 'Admin',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: MyTextfield(
                    hintText: 'Enter your message...',
                    controller: _messageController,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_upward,
                      size: 18,
                    ),
                    onPressed: sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
