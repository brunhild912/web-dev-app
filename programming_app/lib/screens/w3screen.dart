import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../providers/navigation_provider.dart';

class W3Screen extends StatefulWidget {
  const W3Screen({super.key});

  @override
  State<W3Screen> createState() => _W3ScreenState();
}

class _W3ScreenState extends State<W3Screen> {
  late WebViewController _controller;

  @override
  void initState() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate (
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onHttpError: (HttpResponseError error) {},
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
      )
      ..loadRequest(Uri.parse('https://www.w3schools.com/'));
    super.initState();
  }

  Future<bool?> _showBackDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Exit'),
        content: const Text('Do you want to exit the WebView?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    NavigationProvider navigationProvider =
    Provider.of<NavigationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Learn Web Development',
          style: theme.textTheme.bodyMedium
              ?.copyWith(
              fontWeight: FontWeight.bold,
          color: theme.primaryColor),
        ),
      ),
      body: WebViewWidget(controller: _controller),
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
}
