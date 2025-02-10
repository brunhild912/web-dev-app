import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/css.dart';
import 'package:highlight/languages/htmlbars.dart';
import 'package:programming_app/screens/editor%20screens/preview_screen.dart';
import 'package:provider/provider.dart';

import '../../components/helper_widgets.dart';
import '../../providers/editor_navigation_provider.dart';
import '../../providers/theme_provider.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key, required this.folderId});

  final String folderId;

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  CodeController _htmlController = CodeController();
  CodeController _cssController = CodeController();

  String? htmlContent = 'No html content initially';
  String htmlSource = '';

  String? cssContent = 'No css content initially';
  String cssSource = '';

  String cssFileId = '15enn7IWuzXaJpxmQMYT';
  String htmlFileId = 'TyvR4Ke2VVwzvQyWdAou';

  // Preview code method
  void _previewCode(BuildContext context) {
    String htmlContent = _htmlController.text; // Get HTML code
    String cssContent = _cssController.text; // Get CSS code

    // Combine HTML and CSS
    String fullHtml = """
      <!DOCTYPE html>
      <html>
      <head>
        <style>
        $cssContent
        </style>
      </head>
      <body>
        $htmlContent
      </body>
      </html>
      """;

    // Navigate to Preview Screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(htmlContent: fullHtml),
      ),
    );
  }

  //fetch html file data
  Future<void> fetchHtmlContent() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    var db = FirebaseFirestore.instance;

    // Fetch document data from Firestore
    DocumentSnapshot<Map<String, dynamic>> snapshot = await db
        .collection('users')
        .doc(userId)
        .collection('folders')
        .doc(widget.folderId)
        .collection('files')
        .doc(htmlFileId)
        .get();

    // Check if document exists and contains data
    if (snapshot.exists && snapshot.data() != null) {
      Map<String, dynamic>? data = snapshot.data();
      htmlContent = data?['fileContent'];

      if (htmlContent != null) {
        setState(() {
          htmlSource = htmlContent!;
          _htmlController.text =
              htmlSource; // Populate the CodeController with the content
        });
      }
    } else {
      print('Document does not exist or contains no data.');
    }
  }

  //fetch css file data
  Future<void> fetchCssContent() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    var db = FirebaseFirestore.instance;

    // Fetch document data from Firestore
    DocumentSnapshot<Map<String, dynamic>> snapshot = await db
        .collection('users')
        .doc(userId)
        .collection('folders')
        .doc(widget.folderId)
        .collection('files')
        .doc(cssFileId)
        .get();

    // Check if document exists and contains data
    if (snapshot.exists && snapshot.data() != null) {
      Map<String, dynamic>? data = snapshot.data();
      cssContent = data?['fileContent'];

      if (cssContent != null) {
        setState(() {
          cssSource = cssContent!;
          _cssController.text =
              cssSource; // Populate the CodeController with the content
        });
      }
    } else {
      print('Document does not exist or contains no data.');
    }
  }

  // Function to append suggestion to the text field
  void _addHtmlSuggestion(String suggestion) {
    String currentText = _htmlController.text;
    // Append the selected suggestion at the end of the current text
    setState(() {
      _htmlController.text = currentText + suggestion;
      _htmlController.selection = TextSelection.fromPosition(
          TextPosition(offset: _htmlController.text.length));
    });
  }

  void _addCssSuggestion(String suggestion) {
    String currentText = _cssController.text;
    // Append the selected suggestion at the end of the current text
    setState(() {
      _cssController.text = currentText + suggestion;
      _cssController.selection = TextSelection.fromPosition(
          TextPosition(offset: _cssController.text.length));
    });
  }

  @override
  void initState() {
    fetchHtmlContent();
    fetchCssContent();
    _htmlController = CodeController(
      text: htmlSource,
      language: htmlbars,
      patternMap: {
        r'</?[a-zA-Z][^>]*?>':
            const TextStyle(color: Color(0xff7dcfff)), // Blue for tags
        r'\b[a-zA-Z-]+(?=\=)': const TextStyle(
            color: Color(0xFFbb9af7)), // Light brown for attributes
        r'"[^"]*"': const TextStyle(
            color: Color(0xFFD980FA)), // Light orange for attribute values
        r'<!--[\s\S]*?-->':
            const TextStyle(color: Color(0xFFe0af68)), // Green for comments
        r'>([^<]+)<': const TextStyle(
            color: Color(0xFFff9e64)), // Light blue for text content
      },
    );

    _cssController = CodeController(
      text: cssSource,
      language: css,
    );
    super.initState();
  }

  /// *************** SAVE html css files ********************
  Future<void> saveHtmlFile() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    var db = FirebaseFirestore.instance;

    await db
        .collection('users')
        .doc(userId)
        .collection('folders')
        .doc(widget.folderId)
        .collection('files')
        .doc(htmlFileId)
        .update({'fileContent': _htmlController.text});
  }

  Future<void> saveCssFile() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    var db = FirebaseFirestore.instance;

    await db
        .collection('users')
        .doc(userId)
        .collection('folders')
        .doc(widget.folderId)
        .collection('files')
        .doc(cssFileId)
        .update({'fileContent': _cssController.text});
  }

  bool isTabSelected = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    EditorNavigationProvider editorNavigationProvider =
        Provider.of<EditorNavigationProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          addVerticalSpace(20),
          // Navigation tab always at the top
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.folder,
                        color: theme.textTheme.bodyMedium?.color
                            ?.withOpacity(0.9)),
                  ),
                  GestureDetector(
                    onTap: () {
                      editorNavigationProvider.updateIndex(0);
                    },
                    child: _fileTab(theme, 'index.html', Icons.code,
                        editorNavigationProvider.selectedIndex == 0),
                  ),
                  addHorizontalSpace(15),
                  GestureDetector(
                    onTap: () {
                      editorNavigationProvider.updateIndex(1);
                    },
                    child: _fileTab(theme, 'styles.css', Icons.line_style,
                        editorNavigationProvider.selectedIndex == 1),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Consumer<EditorNavigationProvider>(
                builder: (context, editorNavigationProvider, child) {
              return IndexedStack(
                index: editorNavigationProvider
                    .selectedIndex, // Display widget based on selected index
                children: [
                  _htmlCodeContainer(
                    theme,
                  ),
                  _cssCodeContainer(
                    theme,
                  ),
                  // You can add more containers for additional file types
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  // Widget for file tabs (e.g. index.html, styles.css)
  Widget _fileTab(
      ThemeData theme, String fileName, IconData icon, bool isTabSelected) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10.0),
        height: 40,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(5.0),
          border: isTabSelected
              ? Border(
                  bottom: BorderSide(
                    color:
                        theme.primaryColor, // Primary color for the underline
                    width: 3.0, // Thickness of the underline
                  ),
                )
              : null,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: theme.textTheme.bodyMedium?.color),
                addHorizontalSpace(10),
                Text(
                  fileName,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ));
  }

  // Suggestions container
  Widget _htmlSuggestionsContainer(ThemeData theme) {
    final List<String> htmlSuggestions = [
      '<div>',
      '<p>',
      '<h1>',
      '<a>',
      '<ul>',
      '<li>',
      '<img>',
      '<table>'
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
      color: theme.cardColor,
      height: 100,
      width: double.infinity,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 3,
        ),
        itemCount: htmlSuggestions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: ElevatedButton(
              onPressed: () {
                _addHtmlSuggestion(htmlSuggestions[index]);
              },
              child: Text(
                htmlSuggestions[index],
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.scaffoldBackgroundColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _cssSuggestionsContainer(ThemeData theme) {
    final List<String> cssSuggestions = [
      'color: ;',
      'background-color: ;',
      'font-size: ;',
      'margin: ;',
      'padding: ;',
      'border: ;',
      'width: ;',
      'height: ;',
      'display: ;',
      'flex: ;',
      'justify-content: ;',
      'align-items: ;',
      'position: ;',
      'top: ;',
      'right: ;',
      'bottom: ;',
      'left: ;',
      'z-index: ;',
      'overflow: ;',
      'text-align: ;',
      'font-weight: ;',
      'line-height: ;',
      'box-shadow: ;',
      'border-radius: ;',
      'opacity: ;'
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
      color: theme.cardColor,
      height: 100,
      width: double.infinity,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 3,
        ),
        itemCount: cssSuggestions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: ElevatedButton(
              onPressed: () {
                _addCssSuggestion(cssSuggestions[index]);
              },
              child: Text(
                cssSuggestions[index],
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.scaffoldBackgroundColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _htmlCodeContainer(
    var theme,
  ) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      children: [
        // File name with back button and preview buttons
        Container(
          color: theme.cardColor,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: theme.textTheme.labelSmall.color,
                  size: 18,
                ),
              ),
              Text(
                'index.html',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
              const Spacer(),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: IconButton(
                  onPressed: () async {
                    // Call save functions on save button pressed
                    await saveHtmlFile();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Files saved successfully!')),
                    );
                  },
                  icon: Icon(Icons.save, color: theme.primaryColor, size: 20),
                ),
              ),
              addHorizontalSpace(10),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: IconButton(
                  onPressed: () {
                    _previewCode(context);
                  },
                  icon: Icon(Icons.play_arrow,
                      color: theme.primaryColor, size: 20),
                ),
              ),
              addHorizontalSpace(12),
            ],
          ),
        ),

        // Main content area: CodeField and Suggestions, without fixed heights
        Expanded(
          child: Column(
            children: [
              // Code editor area expands to fill available space
              Expanded(
                child: Container(
                  color: theme.cardColor,
                  child: CodeTheme(
                    data: const CodeThemeData(styles: monokaiSublimeTheme),
                    child: CodeField(
                      lineNumberStyle: LineNumberStyle(
                        width: 30.0,
                        textAlign: TextAlign.center,
                        background:
                            theme.scaffoldBackgroundColor.withOpacity(0.2),
                        textStyle: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                      background: themeProvider.codeFieldBackground,
                      controller: _htmlController,
                      expands: true,
                      textStyle: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                        color: themeProvider.codeFieldTextColor,
                      ),
                    ),
                  ),
                ),
              ),

              // Suggestions container fixed at the bottom
              _htmlSuggestionsContainer(theme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _cssCodeContainer(
    var theme,
  ) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      children: [
        // File name with back button and preview buttons
        Container(
          color: theme.cardColor,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                    size: 18, color: theme.textTheme.labelSmall.color),
              ),
              Text(
                'styles.css',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
              const Spacer(),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: IconButton(
                  onPressed: () async {
                    // Call save functions on save button pressed
                    await saveCssFile();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Files saved successfully!')),
                    );
                  },
                  icon: Icon(Icons.save, color: theme.primaryColor, size: 20),
                ),
              ),
              addHorizontalSpace(10),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: IconButton(
                  onPressed: () {
                    _previewCode(context);
                  },
                  icon: Icon(Icons.play_arrow,
                      color: theme.primaryColor, size: 20),
                ),
              ),
              addHorizontalSpace(12),
            ],
          ),
        ),

        // Main content area: CodeField and Suggestions, without fixed heights
        Expanded(
          child: Column(
            children: [
              // Code editor area expands to fill available space
              Expanded(
                child: Container(
                  color: theme.cardColor,
                  child: CodeTheme(
                    data: const CodeThemeData(styles: monokaiSublimeTheme),
                    child: CodeField(
                      lineNumberStyle: LineNumberStyle(
                        width: 30.0,
                        textAlign: TextAlign.center,
                        background:
                            theme.scaffoldBackgroundColor.withOpacity(0.2),
                        textStyle: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                      background: themeProvider.codeFieldBackground,
                      controller: _cssController,
                      expands: true,
                      textStyle: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                        color: themeProvider.codeFieldTextColor,
                      ),
                    ),
                  ),
                ),
              ),

              // Suggestions container fixed at the bottom
              _cssSuggestionsContainer(theme),
            ],
          ),
        ),
      ],
    );
  }
}
