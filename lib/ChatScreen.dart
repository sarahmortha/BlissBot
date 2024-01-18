import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: ChatWidget(),
    );
  }
}

class ChatWidget extends StatefulWidget {
  const ChatWidget({Key? key}) : super(key: key);

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _chatMessages = [];

  bool askingForMotivation = false;
  List<String> motivationalQuotes = [
    "Calmness is the cradle of power.",
    "A crust eaten in peace is better than a banquet partaken in anxiety.",
    "It isn’t the mountain ahead that wears you out; it’s the grain of sand in your shoe.",
  ];
  int currentQuoteIndex = 0;

  void _sendMotivationalQuote() {
    if (currentQuoteIndex < motivationalQuotes.length) {
      _addBlissBotResponse("Here's a motivational quote for you:\n"
          "- ${motivationalQuotes[currentQuoteIndex]}");
      askingForMotivation = true;
      currentQuoteIndex++;
    } else {
      _addBlissBotResponse(
          "I've shared all the motivational quotes. Do you need anything else?");
      askingForMotivation = false;
    }
  }

  void _handleSubmitted(String message) {
    _textController.clear();
    _addUserMessage(message);

    if (askingForMotivation) {
      // User is asked for motivation, check their response
      if (message.toLowerCase().contains('yes')) {
        _sendMotivationalQuote();
      } else {
        _addBlissBotResponse(
            "Okay! Feel free to ask if you need anything else.");
        askingForMotivation = false;
      }
    } else {
      // Process user input and generate BlissBot response
      String blissBotResponse = generateBlissBotResponse(message);

      // Simulate a delayed response from the chatbot
      Future.delayed(const Duration(seconds: 1), () {
        // Add the BlissBot's response to the chat
        _addBlissBotResponse(blissBotResponse);
      });
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
      if (askingForMotivation) {
        _sendMotivationalQuote();
      }
    });
  }

  String generateBlissBotResponse(String userMessage) {
    userMessage = userMessage.toLowerCase();

    if (userMessage.contains('hello') || userMessage.contains('hi')) {
      return "Hello! How can I assist you?";
    } else if (userMessage.contains('motivation') ||
        userMessage.contains('motivate')) {
      askingForMotivation = true;
      currentQuoteIndex = 0;
      return "Sure! Would you like to hear a motivational quote?";
    } else {
      return "I'm here to assist you. Feel free to ask anything!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: _chatMessages.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(_chatMessages[index]),
              );
            },
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
                    hintText: 'Type your message...',
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
