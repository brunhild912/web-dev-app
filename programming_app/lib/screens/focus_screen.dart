import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:programming_app/components/helper_widgets.dart';
import 'package:provider/provider.dart';

import '../model/task.dart';
import '../providers/navigation_provider.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  _FocusScreenState createState() =>
      _FocusScreenState();
}

class _FocusScreenState
    extends State<FocusScreen> {
  final AudioPlayer _rainPlayer = AudioPlayer();
  final AudioPlayer _oceanPlayer = AudioPlayer();
  final AudioPlayer _waterPlayer = AudioPlayer();

  bool isRainPlaying = false;
  bool isOceanPlaying = false;
  bool isWaterPlaying = false;

  bool isRainRepeating = false;
  bool isWaterRepeating = false;
  bool isOceanRepeating = false;

  bool isOceanFavPressed = false;
  bool isRainFavPressed = false;
  bool isWaterFavPressed = false;

  Duration _rainDuration = Duration.zero;
  Duration _rainPosition = Duration.zero;

  Duration _waterDuration = Duration.zero;
  Duration _waterPosition = Duration.zero;

  Duration _oceanDuration = Duration.zero;
  Duration _oceanPosition = Duration.zero;

  bool isDarkMode = false;

  // URLs for the sounds
  final String rainSound = 'audio/rain.mp3';
  final String oceanSound = 'audio/ocean.mp3';
  final String waterSound = 'audio/water.mp3';

  @override
  void initState() {
    super.initState();

    // Fetch tasks for the current user when the screen initializes
    String? userId = getCurrentUserId();
    if (userId != null) {
      fetchTasks(userId);
    }

    // Initialize rain sound player
    _rainPlayer.onDurationChanged
        .listen((duration) {
      setState(() {
        _rainDuration = duration;
      });
    });

    _rainPlayer.onPositionChanged
        .listen((position) {
      setState(() {
        _rainPosition = position;
      });
    });

    // Initialize ocean sound player
    _oceanPlayer.onDurationChanged
        .listen((duration) {
      setState(() {
        _oceanDuration = duration;
      });
    });

    _oceanPlayer.onPositionChanged
        .listen((position) {
      setState(() {
        _oceanPosition = position;
      });
    });

    // Initialize water sound player
    _waterPlayer.onDurationChanged
        .listen((duration) {
      setState(() {
        _waterDuration = duration;
      });
    });

    _waterPlayer.onPositionChanged
        .listen((position) {
      setState(() {
        _waterPosition = position;
      });
    });
  }

  /// ****** SOUNDS *********
  // Function to format time
  String _formatDuration(Duration duration) {
    String twoDigits(int n) =>
        n.toString().padLeft(2, '0');
    final minutes = twoDigits(
        duration.inMinutes.remainder(60));
    final seconds = twoDigits(
        duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;
  List<Task> tasks = []; // Store fetched tasks

  // Get current user's ID
  String? getCurrentUserId() {
    User? user = FirebaseAuth.instance
        .currentUser; // Get the current user
    return user
        ?.uid; // Return the user's ID (uid) or null if not authenticated
  }

  Future<void> fetchTasks(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('tasks')
          .get();

      // Map fetched documents to Task objects
      tasks = snapshot.docs.map((doc) {
        return Task(
          id: doc.id, // Firestore-generated ID
          heading: doc['heading'],
          description: doc['description'],
          dateAssigned: doc['dateAssigned'],
          deadline: doc['deadline'],
          isDone: doc['isDone'],
        );
      }).toList();

      print(
          "Tasks fetched successfully for user: $userId.");
      setState(
          () {}); // Refresh the UI with the new task data
    } catch (e) {
      print("Error fetching tasks: $e");
    }
  }

  Future<void> _toggleTaskCompletion(
      String taskId, bool currentStatus) async {
    String? userId =
        getCurrentUserId(); // Ensure this returns the correct userId
    if (userId == null) {
      print(
          "Error: User ID is null. Cannot proceed with task update.");
      return;
    }

    // Debugging: Print the userId and taskId
    print(
        "Updating task status for userId: $userId, taskId: $taskId");

    try {
      // Check if the task exists
      var taskDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('tasks')
          .doc(taskId)
          .get();

      if (!taskDoc.exists) {
        print(
            "Error: Task with ID $taskId does not exist for user $userId.");
        return;
      }

      // If the document exists, proceed with updating
      await taskDoc.reference.update({
        'isDone': !currentStatus,
      });
      print(
          "Task status updated successfully for $userId");
      // Update the local tasks list to reflect the change
      setState(() {
        final index = tasks.indexWhere(
            (task) => task.id == taskId);
        if (index != -1) {
          tasks[index].isDone =
              !currentStatus; // Update the local task status
        }
      });
    } catch (e) {
      print("Error updating task status: $e");
    }
  }

  @override
  void dispose() {
    // Dispose of audio players when not in use
    _rainPlayer.dispose();
    _oceanPlayer.dispose();
    _waterPlayer.dispose();
    super.dispose();
  }

  void _toggleRainFavorite() {
    setState(() {
      isRainFavPressed = !isRainFavPressed;
    });
  }

  void _toggleWaterFavorite() {
    setState(() {
      isWaterFavPressed = !isWaterFavPressed;
    });
  }

  void _toggleOceanFavorite() {
    setState(() {
      isOceanFavPressed = !isOceanFavPressed;
    });
  }

  // Toggle play/pause for Rain
  void _toggleRainPlayPause() {
    if (isRainPlaying) {
      _rainPlayer.pause();
    } else {
      _rainPlayer.play(AssetSource(rainSound));
    }
    setState(() {
      isRainPlaying = !isRainPlaying;
    });
  }

  // Toggle repeat for Rain
  void _toggleRainRepeat() {
    if (isRainRepeating) {
      _rainPlayer.setReleaseMode(
          ReleaseMode.stop); // Stop repeating
    } else {
      _rainPlayer.setReleaseMode(
          ReleaseMode.loop); // Repeat
    }
    setState(() {
      isRainRepeating = !isRainRepeating;
    });
  }

  // Toggle play/pause for Ocean
  void _toggleOceanPlayPause() {
    if (isOceanPlaying) {
      _oceanPlayer.pause();
    } else {
      _oceanPlayer.play(AssetSource(oceanSound));
    }
    setState(() {
      isOceanPlaying = !isOceanPlaying;
    });
  }

  // Toggle repeat for Ocean
  void _toggleOceanRepeat() {
    if (isOceanRepeating) {
      _oceanPlayer.setReleaseMode(
          ReleaseMode.stop); // Stop repeating
    } else {
      _oceanPlayer.setReleaseMode(
          ReleaseMode.loop); // Repeat
    }
    setState(() {
      isOceanRepeating = !isOceanRepeating;
    });
  }

  // Toggle play/pause for Water
  void _toggleWaterPlayPause() {
    if (isWaterPlaying) {
      _waterPlayer.pause();
    } else {
      _waterPlayer.play(AssetSource(waterSound));
    }
    setState(() {
      isWaterPlaying = !isWaterPlaying;
    });
  }

  // Toggle repeat for Water
  void _toggleWaterRepeat() {
    if (isWaterRepeating) {
      _waterPlayer.setReleaseMode(
          ReleaseMode.stop); // Stop repeating
    } else {
      _waterPlayer.setReleaseMode(
          ReleaseMode.loop); // Repeat
    }
    setState(() {
      isWaterRepeating = !isWaterRepeating;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    ///******* NAVIGATION PROVIDER ********
    NavigationProvider navigationProvider =
        Provider.of<NavigationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Focus',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            /******* Tasks assigned by the system ********/
            addVerticalSpace(20),
            Text(
              'The 7 Days Coding Challenge',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: theme.textTheme
                    .displayLarge?.color,
              ),
            ),
            addVerticalSpace(10),

            //small heading
            Text(
              'Finish the task and get a new one!',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.start,
            ),

            addVerticalSpace(10),
            tasks.isEmpty
                ? Center(
                    child:
                        CircularProgressIndicator(
                    color: theme.primaryColor,
                  ))
                : ListView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount: tasks.length,
                    itemBuilder:
                        (context, index) {
                      var task = tasks[index];
                      return Card(
                        color: theme.cardColor,
                        margin: const EdgeInsets
                            .symmetric(
                            vertical: 8.0),
                        child: ListTile(
                          title: Text(
                            task.heading,
                          style: theme.textTheme.bodyMedium
                          ?.copyWith(
                          fontWeight:
                          FontWeight.bold, fontSize: 18, color: theme.primaryColor,
                          ),),
                          subtitle: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              addVerticalSpace(20),
                              Text('Description: ', style: theme.textTheme.bodyLarge,),
                              Text(
                                 task.description),
                              addVerticalSpace(10),
                              Text('Assigned: ', style: theme.textTheme.bodyLarge,),
                              Text(
                                  task.dateAssigned),
                              addVerticalSpace(10),
                              Text('Deadline: ', style: theme.textTheme.bodyLarge,),
                              Text(
                                 task.deadline),
                              addVerticalSpace(10),
                              Text('Status: ', style: theme.textTheme.bodyLarge,),
                              Text(
                                 task.isDone ? "Completed" : "Pending"),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                task.isDone = !task
                                    .isDone; // Toggle status for display
                              });
                            },
                            icon: Icon(
                              task.isDone
                                  ? Icons
                                      .check_circle
                                  : Icons
                                      .radio_button_unchecked,
                              color: task.isDone
                                  ? theme
                                      .primaryColor
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

            addVerticalSpace(20),

            /********* Sounds Section **********/
            Text(
              'Tune into focus',
              style: theme.textTheme.displayLarge,
            ),
            addVerticalSpace(20),

            // Audio Section
            // Rain Audio Player
            _buildAudioPlayer(
              title: 'Rain Sound',
              isPlaying: isRainPlaying,
              isRepeating: isRainRepeating,
              onPlayPausePressed:
                  _toggleRainPlayPause,
              onRepeatPressed: _toggleRainRepeat,
              duration: _rainDuration,
              position: _rainPosition,
              theme: theme,
              isFavPressed: isRainFavPressed,
              toggleFav: _toggleRainFavorite,
            ),
            addVerticalSpace(20),
            // Ocean Audio Player
            _buildAudioPlayer(
                title: 'Ocean Sound',
                isPlaying: isOceanPlaying,
                isRepeating: isOceanRepeating,
                onPlayPausePressed:
                    _toggleOceanPlayPause,
                onRepeatPressed:
                    _toggleOceanRepeat,
                duration: _oceanDuration,
                position: _oceanPosition,
                theme: theme,
                isFavPressed: isOceanFavPressed,
                toggleFav: _toggleOceanFavorite),
            addVerticalSpace(20),
            // Water Audio Player
            _buildAudioPlayer(
              title: 'Water Sound',
              isPlaying: isWaterPlaying,
              isRepeating: isWaterRepeating,
              onPlayPausePressed:
                  _toggleWaterPlayPause,
              onRepeatPressed: _toggleWaterRepeat,
              duration: _waterDuration,
              position: _waterPosition,
              theme: theme,
              isFavPressed: isWaterFavPressed,
              toggleFav: _toggleWaterFavorite,
            ),
            addVerticalSpace(
                20), // Add vertical space
          ],
        ),
      ),
      bottomNavigationBar:
          Consumer<NavigationProvider>(builder:
              (context, navigationProvider,
                  child) {
        return BottomNavigationBar(
          currentIndex:
              navigationProvider.selectedIndex,
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
              icon:
              Icon(Icons.folder_open_rounded),
              label: "Folders",
            ),
            BottomNavigationBarItem(
              icon:
              Icon(Icons.filter_center_focus),
              label: 'Focus',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                  Icons.person_outline_rounded),
              label: 'Profile',
            ),
          ],
        );
      }),
    );
  }

  // Widget for each individual audio player
  Widget _buildAudioPlayer({
    required String title,
    required bool isPlaying,
    required bool isRepeating,
    required VoidCallback onPlayPausePressed,
    required VoidCallback onRepeatPressed,
    required Duration duration,
    required Duration position,
    required var theme,
    required bool isFavPressed,
    required VoidCallback toggleFav,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyMedium
              ?.copyWith(
                  fontWeight: FontWeight.bold),
        ),
        addVerticalSpace(20),
        // Progress Bar and Time Display
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                children: [
                  // Current position
                  Text(
                    _formatDuration(position),
                    style: theme
                        .textTheme.labelSmall,
                  ),
                  // Total duration
                  Text(
                    _formatDuration(
                        duration - position),
                    style: theme
                        .textTheme.labelSmall,
                  ),
                ],
              ),
              Slider(
                min: 0,
                max:
                    duration.inSeconds.toDouble(),
                value:
                    position.inSeconds.toDouble(),
                onChanged: (value) {
                  setState(() {
                    _rainPlayer.seek(Duration(
                        seconds: value.toInt()));
                  });
                },
                activeColor: theme.primaryColor,
                inactiveColor: theme.cardColor,
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceAround,
          children: [
            // Add button fav
            IconButton(
              icon: isFavPressed
                  ? Icon(Icons.favorite,
                      size: 20,
                      color: theme.primaryColor)
                  : Icon(Icons.favorite_outline,
                      size: 20,
                      color: theme.textTheme
                          .labelSmall.color),
              onPressed: toggleFav,
            ),
            // Play/Pause button (middle)
            IconButton(
              icon: Icon(
                isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
                size: 40,
                color: theme
                    .textTheme.labelSmall.color,
              ),
              onPressed: onPlayPausePressed,
            ),
            // Repeat button (right)
            IconButton(
              icon: Icon(
                Icons.repeat,
                size: 20,
                color: isRepeating
                    ? theme.primaryColor
                    : theme.textTheme.labelSmall
                        .color,
              ),
              onPressed: onRepeatPressed,
            ),
          ],
        ),
        addVerticalSpace(20),
        const Divider(),
      ],
    );
  }
}
