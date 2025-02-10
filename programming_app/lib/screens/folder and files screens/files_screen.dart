import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:programming_app/screens/editor%20screens/editor_screen.dart';

import '../../components/helper_widgets.dart';
import 'file_content_screen.dart';

class FileScreen extends StatefulWidget {
  final String folderId;
  final String folderName;

  const FileScreen(
      {super.key, required this.folderId, required this.folderName});

  @override
  _FileScreenState createState() => _FileScreenState();
}

class _FileScreenState extends State<FileScreen> {
  final List<String> files =
      []; // Placeholder for the list of files in the folder

  TextEditingController fileNameController = TextEditingController();
  TextEditingController fileContentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //load files
    Stream<List<Map<String, dynamic>>> getFiles() {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      var db = FirebaseFirestore.instance;
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      final userDataStream = users
          .doc(userId)
          .collection('folders')
          .doc(widget.folderId)
          .collection('files')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          var data = doc.data();
          data['fileId'] = doc.id; // Add document ID
          return data;
        }).toList();
      });

      return userDataStream;
    }

    var theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.folderName,
          style:
              theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 17,
            )),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: getFiles(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: theme.primaryColor,
              strokeWidth: 6,
            ));
          }

          var files = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
            child: Column(
              children: [
                const SizedBox(height: 35),
                // Add "Files" Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Files',
                      style: theme.textTheme.displayLarge,
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 10),

                //files containers
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of folders per row
                      mainAxisSpacing: 20, // Spacing between rows
                      crossAxisSpacing: 20, // Spacing between columns
                      childAspectRatio: (width / 2) / (width / 2),
                    ),
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      var file = files[index];
                      var fileId = file['fileId'];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FileContentScreen(
                                  fileId: fileId,
                                  folderId: widget.folderId,
                                ),
                              ));
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(15),
                          height: width / 2.5,
                          width: width / 2.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: theme.cardColor,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: theme.scaffoldBackgroundColor,
                                ),
                                child: Icon(
                                  Icons.file_copy,
                                  color: theme.primaryColor,
                                ),
                              ),
                              addVerticalSpace(5),
                              Text(
                                file['fileName'],
                                style: theme.textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Row(
        children: [
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditorScreen(folderId: widget.folderId),
                ),
              );
            },
            child: Row(
              children: [
                Text(
                  'Go to Editor Screen',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                addHorizontalSpace(10),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: theme.primaryColor,
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    color: theme.scaffoldBackgroundColor,
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
