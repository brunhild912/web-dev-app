import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/helper_widgets.dart';
import '../../providers/navigation_provider.dart';
import 'files_screen.dart';

class FoldersScreen extends StatelessWidget {
  const FoldersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ///******* NAVIGATION PROVIDER ********
    NavigationProvider navigationProvider =
        Provider.of<NavigationProvider>(context);

    String fowlderId = '';

    //get current user's id
    String? getCurrentUserId() {
      User? user = FirebaseAuth.instance.currentUser; // Get the current user
      return user
          ?.uid; // Return the user's ID (uid) or null if not authenticated
    }

    //fetch file ids
    Future<List<String>> fetchFileIds(String folderId) async {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      var db = FirebaseFirestore.instance;

      List<String> fileIds = [];

      try {
        // Query the files in the specified folder
        QuerySnapshot filesSnapshot = await db
            .collection('users')
            .doc(userId)
            .collection('folders')
            .doc(folderId)
            .collection('files')
            .get();

        // Iterate through each document in the snapshot
        for (var fileDoc in filesSnapshot.docs) {
          // Add the fileId to the list
          fileIds.add(fileDoc.id);
        }
      } catch (e) {
        print('Error fetching file IDs: $e');
      }

      return fileIds;
    }

    void displayFileIds(String folderId) async {
      List<String> fileIds = await fetchFileIds(folderId);
      print("File IDs: $fileIds");
    }

    // Function to create default files for the folder
    Future<void> createDefaultFiles(String folderId) async {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      var db = FirebaseFirestore.instance;

      // Default file details
      List<Map<String, dynamic>> defaultFiles = [
        {'fileName': 'index.html', 'fileContent': '<!-- HTML content -->'},
        {'fileName': 'styles.css', 'fileContent': '/* CSS content */'},
        {'fileName': 'images', 'fileContent': 'No image content to display yet'}
      ];

      for (var file in defaultFiles) {
        // Generate a new file ID
        String fileId = db
            .collection('users')
            .doc(userId)
            .collection('folders')
            .doc(folderId)
            .collection('files')
            .doc()
            .id;

        // File data
        final fileData = <String, dynamic>{
          'fileId': fileId,
          'fileName': file['fileName'],
          'fileContent': file['fileContent'],
          'createdAt': FieldValue.serverTimestamp(),
        };

        // Add the file to the folder's 'files' collection
        await db
            .collection('users')
            .doc(userId)
            .collection('folders')
            .doc(folderId)
            .collection('files')
            .doc(fileId)
            .set(fileData);
      }
    }

    //create a folder in firebase
    Future<void> createFolder(String folderName) async {
      String? userId = getCurrentUserId();
      var db = FirebaseFirestore.instance;

      // Generate a new folderId
      String folderId =
          db.collection('users').doc(userId).collection('folders').doc().id;

      fowlderId = folderId;

      final folderData = <String, dynamic>{
        'folderId': folderId,
        'folderName': folderName,
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Add folder to the folders subcollection
      await db
          .collection('users')
          .doc(userId)
          .collection('folders')
          .doc(folderId)
          .set(folderData)
          .onError((e, _) => print("Error writing folder: $e"));

      // Now automatically add the 3 default files in this folder
      await createDefaultFiles(folderId);
    }

    ///******* delete a folder
    //helper function to delete files in a folder
    Future<void> deleteAllFilesInFolder(String folderId) async {
      String? userId = getCurrentUserId();
      var db = FirebaseFirestore.instance;

      var files = await db
          .collection('users')
          .doc(userId)
          .collection('folders')
          .doc(folderId)
          .collection('files')
          .get();

      for (var file in files.docs) {
        await file.reference.delete();
      }

      print("All files in the folder deleted successfully");
    }

    //delete folder
    Future<void> deleteFolder(String folderId) async {
      String? userId = getCurrentUserId();
      var db = FirebaseFirestore.instance;

      try {
        // Delete all files within the folder (optional, if needed)
        await deleteAllFilesInFolder(folderId);

        // Delete the folder itself
        await db
            .collection('users')
            .doc(userId)
            .collection('folders')
            .doc(folderId)
            .delete();

        print("Folder deleted successfully");
      } catch (e) {
        print("Error deleting folder: $e");
      }
    }

    ////**** rename a folder
    Future<void> renameFolder(String folderId, String newFolderName) async {
      String? userId = getCurrentUserId();
      var db = FirebaseFirestore.instance;

      try {
        // Update the folder's name in Firestore
        await db
            .collection('users')
            .doc(userId)
            .collection('folders')
            .doc(folderId)
            .update({'folderName': newFolderName});
        print("Folder renamed successfully");
      } catch (e) {
        print("Error renaming folder: $e");
      }
    }

    void showRenameFolderDialog(
        BuildContext context, var theme, String folderId) {
      TextEditingController newFolderNameController = TextEditingController();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Rename Folder',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              content: TextField(
                controller: newFolderNameController,
                decoration: InputDecoration(
                    hintText: 'Enter new name for your folder',
                    hintStyle: theme.textTheme.labelSmall),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'OK',
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    renameFolder(folderId, newFolderNameController.text);
                    newFolderNameController.clear(); // Clear the input field
                    Navigator.of(context).pop();
                  },
                ),
                const Spacer(),
                TextButton(
                  child: Text(
                    'Cancel',
                    style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold, color: theme.primaryColor),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          });
    }

    ///********** DIALOG TO DELETE OR RENAME A FOLDER
    void showFolderOptionsDialog(
        BuildContext context, String folderName, String folderId, var theme) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: theme.scaffoldBackgroundColor,
            title: Text(
              'Folder Options',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            content: Text('What would you like to do with "$folderName"?',
                style: theme.textTheme.labelSmall),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      showRenameFolderDialog(context, theme, folderId);
                    },
                    child: Text('Rename',
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodyMedium?.color,
                            fontWeight: FontWeight.bold)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      deleteFolder(folderId);
                    },
                    child: Text('Delete',
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodyMedium?.color,
                            fontWeight: FontWeight.bold)),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pop(), // Close dialog
                    child: Text(
                      'Cancel',
                      style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }

    //read folders data
    Stream<List<Map<String, dynamic>>> getFolders() {
      String? userId = getCurrentUserId();
      var db = FirebaseFirestore.instance;

      return db
          .collection('users')
          .doc(userId)
          .collection('folders')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return doc.data();
        }).toList();
      });
    }

    //new folder dialog
    void showAddFolderDialog(BuildContext context, var theme) {
      String? userID = getCurrentUserId();
      TextEditingController folderNameController = TextEditingController();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: theme.scaffoldBackgroundColor,
            title: Text(
              'New Folder',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            content: TextField(
              controller: folderNameController,
              decoration: InputDecoration(
                  hintText: 'Enter folder name',
                  hintStyle: theme.textTheme.labelSmall),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK',
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.bold)),
                onPressed: () {
                  createFolder(folderNameController.text);
                  folderNameController.clear(); // Clear the input field
                  Navigator.of(context).pop();
                },
              ),
              const Spacer(),
              TextButton(
                child: Text(
                  'Cancel',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold, color: theme.primaryColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }

    var theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 60,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
              ),
            ),
            Text(
              '  /codiefy',
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: theme.primaryColor),
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: getFolders(),
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

          // Data is available
          var folders = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
            child: Column(
              children: [
                const SizedBox(height: 35),
                // Add "My Folders" Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'My Folders',
                      style: theme.textTheme.displayLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    displayFileIds(fowlderId);
                  },
                  child: const Text('View File Ids'),
                ),
                //folders list
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of folders per row
                      mainAxisSpacing: 20, // Spacing between rows
                      crossAxisSpacing: 20, // Spacing between columns
                      childAspectRatio: (width / 2) / (width / 2),
                    ),
                    itemCount: folders.length,
                    itemBuilder: (context, index) {
                      var folder = folders[index];
                      return GestureDetector(
                        onLongPress: () {
                          showFolderOptionsDialog(context, folder['folderName'],
                              folder['folderId'], theme);
                        },
                        onTap: () {
                          // Navigate to the FileScreen and pass the folder data
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FileScreen(
                                folderId: folder['folderId'], // Pass folder ID
                                folderName: folder[
                                    'folderName'], // Pass folder name for the AppBar
                              ),
                            ),
                          );
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
                                  Icons.folder,
                                  color: theme.primaryColor,
                                ),
                              ),
                              addVerticalSpace(5),
                              Text(
                                folder['folderName'],
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.primaryColor,
        foregroundColor: theme.scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () {
          showAddFolderDialog(context, theme);
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: Consumer<NavigationProvider>(
          builder: (context, navigationProvider, child) {
        return BottomNavigationBar(
          currentIndex: navigationProvider.selectedIndex,
          onTap: (index) {
            navigationProvider.updateIndex(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined), // Icon for the Learn tab
              label: 'Learn',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_open_rounded),
              label: "Folders",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.filter_center_focus),
              label: 'Focus',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              label: 'Profile',
            ),
          ],
        );
      }),
    );
  }
}
