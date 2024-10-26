import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatMessage> messages = [
    ChatMessage(
      sender: "Patient",
      text: "What medications are effective for heart failure?",
      timestamp: "10:30 AM",
    ),
    ChatMessage(
      sender: "Doctor",
      text: "Common medications include ACE inhibitors, beta-blockers, and diuretics.",
      timestamp: "10:31 AM",
    ),
    ChatMessage(
      sender: "Patient",
      text: "Are there any side effects I should be aware of?",
      timestamp: "10:32 AM",
    ),
    ChatMessage(
      sender: "Doctor",
      text: "Some may experience dizziness or low blood pressure. It’s important to monitor your symptoms.",
      timestamp: "10:33 AM",
    ),
    // Additional previous questions
    ChatMessage(
      sender: "Patient",
      text: "How often should I check my blood pressure?",
      timestamp: "10:34 AM",
    ),
    ChatMessage(
      sender: "Doctor",
      text: "It is recommended to check your blood pressure at least once a week.",
      timestamp: "10:35 AM",
    ),
    ChatMessage(
      sender: "Patient",
      text: "What should I do if my blood pressure is high?",
      timestamp: "10:36 AM",
    ),
    ChatMessage(
      sender: "Doctor",
      text: "Consult with your doctor immediately if your readings are consistently high.",
      timestamp: "10:37 AM",
    ),
  ];

  String selectedDoctor = 'Dr. John Doe'; // Default selected doctor
  final List<String> doctors = [
    'Dr. John Doe',
    'Dr. Jane Smith',
    'Dr. Rajesh Kumar',
    'Dr. Priya Menon',
    'Dr. Amit Desai',
    'Dr. Sanjay Gupta',
  ];

  final TextEditingController _controller = TextEditingController();

  void _sendMessage(String text) {
    if (text.isNotEmpty) {
      setState(() {
        messages.insert(
          0,
          ChatMessage(
            sender: "Patient",
            text: text,
            timestamp: "Now",
          ),
        );
        messages.insert(
          0,
          ChatMessage(
            sender: "System",
            text: "Your question was successfully sent to $selectedDoctor.",
            timestamp: "Now",
          ),
        );
        _controller.clear(); // Clear the input field after sending
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cardio Care Chat',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedDoctor,
              onChanged: (String? newValue) {
                setState(() {
                  selectedDoctor = newValue!;
                });
              },
              items: doctors.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: _sendMessage,
                    decoration: InputDecoration(
                      labelText: "Ask a question...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_controller.text);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ChatHistory(messages: messages),
          ),
        ],
      ),
    );
  }
}

class ChatHistory extends StatelessWidget {
  final List<ChatMessage> messages;

  const ChatHistory({required this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return ChatBubble(message: messages[index]);
      },
    );
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isPatient = message.sender == "Patient";
    final isSystem = message.sender == "System";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Align(
        alignment: isSystem
            ? Alignment.center
            : (isPatient ? Alignment.centerRight : Alignment.centerLeft),
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isSystem
                ? Colors.green[100]
                : (isPatient ? Colors.blue[100] : Colors.red[100]),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
            isPatient ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                message.text,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                message.timestamp,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String sender;
  final String text;
  final String timestamp;

  ChatMessage({
    required this.sender,
    required this.text,
    required this.timestamp,
  });
}

void main() {
  runApp(MaterialApp(
    home: ChatPage(),
  ));
}
