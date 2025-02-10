import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class PreviewScreen extends StatelessWidget {
  final String htmlContent;

  const PreviewScreen({super.key, required this.htmlContent});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Preview',
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
      body: SingleChildScrollView(
        child: Html(data: htmlContent),
      ),
    );
  }
}
