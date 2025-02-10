import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:programming_app/components/helper_widgets.dart';

class FileContentScreen extends StatelessWidget {
  const FileContentScreen({
    super.key,
    required this.fileId,
    required this.folderId,
  });

  final String? fileId;
  final String folderId;

  // Method to get file data from Firestore
  Future<Map<String, String>> getFileData(
      String? fileId, String folderId) async {
    String? userId =
        FirebaseAuth.instance.currentUser?.uid;
    CollectionReference users = FirebaseFirestore
        .instance
        .collection('users');

    // Fetch the file data from Firestore
    DocumentSnapshot fileSnapshot = await users
        .doc(userId)
        .collection('folders')
        .doc(folderId)
        .collection('files')
        .doc(fileId)
        .get();

    // Check if the document exists and return the data
    if (fileSnapshot.exists) {
      String fileName =
          fileSnapshot.get('fileName') ??
              'Untitled';
      String fileContent =
          fileSnapshot.get('fileContent') ??
              'No content available';

      return {
        'fileName': fileName,
        'fileContent': fileContent,
      };
    } else {
      throw Exception("File not found.");
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'File Content',
          style: theme.textTheme.bodyMedium
              ?.copyWith(
                  fontWeight: FontWeight.bold),
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
      body: FutureBuilder<Map<String, String>>(
        future: getFileData(fileId,
            folderId), // Call the function to fetch file data
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, String>>
                snapshot) {
          // Handle loading state
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.primaryColor,
                strokeWidth: 6,
              ),
            );
          }

          // Handle error state
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  'Error: ${snapshot.error}'),
            );
          }

          // Once data is fetched, display the fileName and fileContent
          if (snapshot.hasData) {
            String fileName =
                snapshot.data!['fileName'] ??
                    'Untitled';
            String fileContent =
                snapshot.data!['fileContent'] ??
                    'No content available';

            return Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8, horizontal: 12),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  addVerticalSpace(35),
                  Text(
                    fileName,
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge,
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        fileContent,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // Default case (shouldn't occur)
          return const Center(
            child: Text('No data available'),
          );
        },
      ),
    );
  }
}
