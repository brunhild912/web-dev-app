import 'package:flutter/material.dart';
import 'package:programming_app/components/helper_widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LearnMorePage extends StatefulWidget {
  const LearnMorePage({super.key});

  @override
  _LearnMorePageState createState() => _LearnMorePageState();
}

class _LearnMorePageState extends State<LearnMorePage> {
  final PageController _controller = PageController();

  final List<Map<String, String>> subTopics = [
    {
      'title': 'Integrated Code Editor',
      'description':
          'Experience seamless coding with our integrated code editor, allowing you to write and preview your code in one convenient place. Enhance your workflow and productivity as you see real-time results without switching screens.',
    },
    {
      'title': 'Calming Soundscapes',
      'description':
          'Stay focused and relaxed while coding with our selection of calming soundscapes. Choose from soothing ambient sounds that help create an optimal coding environment, boosting your concentration and creativity.',
    },
    {
      'title': 'Task Management System',
      'description':
          'Keep track of your assignments with our task management system. Users can view tasks assigned by the admin, submit their completed work, and maintain accountability and discipline in their coding journey.',
    },
    {
      'title': 'Customizable Themes',
      'description':
          'Personalize your coding experience with customizable color themes. Choose from light, dark, or vibrant options to create a coding environment that suits your style and enhances your comfort.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 17,
            )),
        title: Row(
          children: [
            Text(
              'Learn More About',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            addHorizontalSpace(10),
            Text(
              '/codiefy',
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: theme.primaryColor),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: subTopics.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        subTopics[index]['title']!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        subTopics[index]['description']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Add the SmoothPageIndicator below the PageView
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SmoothPageIndicator(
              controller: _controller, // PageController
              count: subTopics.length,
              effect: WormEffect(
                dotHeight: 12,
                dotWidth: 12,
                spacing: 8,
                // Customize the colors for the dots
                dotColor: theme.secondaryHeaderColor, // Inactive color
                activeDotColor: theme.primaryColor, // Active color
              ),
            ),
          ),
        ],
      ),
    );
  }
}
