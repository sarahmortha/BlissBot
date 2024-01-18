import 'package:blissbot2/core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'BlissBot',
      navigatorKey: Get.navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromARGB(
          255,
          111,
          209,
          255,
        ), // Set the background color
      ),
      home: const NewBlissBotScreen(),
    ),
  );
}

class NewBlissBotScreen extends StatelessWidget {
  const NewBlissBotScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BlissBot'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'BlissBot',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'BlissBot is a supportive chat app designed to ease exam stress and anxiety, providing personalized conversations and relaxation resources for students and individuals.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewChatScreen(),
                  ),
                );
              },
              child: const Text('Open Chat'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
              child: const Text('Open Settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class NewChatScreen extends StatelessWidget {
  const NewChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: NewChatWidget(),
    );
  }
}

class NewChatWidget extends StatefulWidget {
  const NewChatWidget({Key? key}) : super(key: key);

  @override
  _NewChatWidgetState createState() => _NewChatWidgetState();
}

class _NewChatWidgetState extends State<NewChatWidget>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final List<String> _chatMessages = [];

  bool askingForMeditationTechnique = false;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _sendInitialPrompts();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _sendInitialPrompts() {
    _addBlissBotResponse(
        "Hello! I'm BlissBot. How can I assist you today? Here are some options:\n"
        "1. Do you want to meditate?\n"
        "2. Do you need to relax?");
  }

  void _handleSubmitted(String message) {
    _textController.clear();
    _addUserMessage(message);

    // Process user input and generate BlissBot response
    String blissBotResponse = generateBlissBotResponse(message);

    // Simulate a delayed response from the chatbot
    Future.delayed(const Duration(seconds: 1), () {
      // Add the BlissBot's response to the chat
      _addBlissBotResponse(blissBotResponse);
      _animateChat();
    });
  }

  String generateBlissBotResponse(String userMessage) {
    userMessage = userMessage.toLowerCase();

    switch (userMessage) {
      case '1':
        askingForMeditationTechnique = true;
        return "Great! Here are some meditation techniques to choose from:\n"
            "A. Deep Breathing\n"
            "B. Mindful Observation\n"
            "C. Guided Imagery";
      case '2':
        return "Relaxation is important. Take a deep breath and let go of any tension.";
      case 'a':
        return "Deep Breathing Technique:\n"
            "1. Inhale deeply for a count of four.\n"
            "2. Hold your breath for four counts.\n"
            "3. Exhale slowly for four counts.\n"
            "4. Repeat.";
      case 'b':
        return "Mindful Observation Technique:\n"
            "1. Focus on one object.\n"
            "2. Notice its details, colors, and textures.\n"
            "3. This helps redirect your mind from anxiety.";
      case 'c':
        return "Guided Imagery Technique:\n"
            "1. Close your eyes and imagine a peaceful place.\n"
            "2. Engage your senses in this mental escape.";
      default:
        return "I'm here to assist you. Feel free to ask anything!";
    }
  }

  void _addUserMessage(String message) {
    setState(() {
      _chatMessages.add('You: $message');
    });
  }

  void _addBlissBotResponse(String response) {
    setState(() {
      _chatMessages.add('BlissBot: $response');
      if (askingForMeditationTechnique) {
        _sendMeditationTechniques();
      }
    });
  }

  void _sendMeditationTechniques() {
    askingForMeditationTechnique = false;
    // Asking the user to choose a technique
    _addBlissBotResponse(
        "Please choose a meditation technique by typing its letter:\n"
        "A. Deep Breathing\n"
        "B. Mindful Observation\n"
        "C. Guided Imagery");
  }

  void _animateChat() {
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: ListView.builder(
              itemCount: _chatMessages.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_chatMessages[index]),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _textController,
                  onSubmitted: _handleSubmitted,
                  decoration: const InputDecoration(
                    hintText: 'Type your message (1, 2, 3)...',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('This is the settings page!'),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isDarkTheme = !_isDarkTheme;
                });

                if (_isDarkTheme) {
                  // Set the theme to dark
                  Get.changeTheme(ThemeData.dark().copyWith(
                    primaryColor: Colors.blue,
                    scaffoldBackgroundColor:
                        const Color.fromARGB(255, 0, 56, 101),
                    textTheme: TextTheme(
                      bodyText2: TextStyle(color: Colors.white),
                    ),
                  ));
                } else {
                  // Set the theme to light
                  Get.changeTheme(ThemeData.light());
                }
              },
              child: Text(_isDarkTheme
                  ? 'Switch to Light Theme'
                  : 'Switch to Dark Theme'),
            ),
          ],
        ),
      ),
    );
  }
}
