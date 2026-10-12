import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AvatarChatPage(),
    );
  }
}

Map<String, dynamic> companions = {
  "luna": {
    "name": "Luna",
    "pitch": 1.2,
    "rate": 0.45,
    "style": "soft",
  },
  "kai": {
    "name": "Kai",
    "pitch": 0.9,
    "rate": 0.55,
    "style": "bold",
  }
};



class AvatarChatPage extends StatefulWidget {
  const AvatarChatPage({super.key});

  @override
  State<AvatarChatPage> createState() => _AvatarChatPageState();
}

class _AvatarChatPageState extends State<AvatarChatPage> {
  final FlutterTts tts = FlutterTts();
  final TextEditingController _controller = TextEditingController();
  final SpeechToText speech = SpeechToText();

  bool isListening = false;
  String userText = "";

  String avatarExpression = "neutral";
  String lastMessage = "";

  String selectedCompanion = "luna";
  
  @override
void initState() {
  super.initState();
  initTts();
  initSpeech();
} // 🌙 luna or ☀️ kai

 void initTts() {
  tts.setLanguage("en-US");
  tts.setSpeechRate(0.5);
  tts.setPitch(1.0);
}

  @override
  void dispose() {
    tts.stop();
    _controller.dispose();
    super.dispose();
  }
// Voice input handling
Future<void> sendMessageFromVoice(String text) async {
  setState(() {
    lastMessage = text;
    avatarExpression = "thinking";
  });

  try {
    String aiResponse = await getAIResponse(text);

    setState(() {
      avatarExpression = "talking";
    });

    await applyVoiceStyle();
    await tts.speak(aiResponse);

  } catch (e) {
    await tts.speak("Come again?");
  }

  setState(() {
    avatarExpression = "neutral";
  });
}

  //AI Function
Future<String> getAIResponse(String userText) async {
  final url = Uri.parse("http://127.0.0.1:3000/chat");

  print("Sending request...");
  print("Message: $userText");
  print("Companion: $selectedCompanion");

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "message": userText,
        "companion": selectedCompanion,
      }),
    );

    print("STATUS: ${response.statusCode}");
    print(" BODY: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["reply"];
    } else {
      return "Server error: ${response.statusCode}";
    }
  } catch (e) {
    print("ERROR: $e");
    return "Connection failed";
  }
}

  Future<void> applyVoiceStyle() async {
  var c = companions[selectedCompanion];

  await tts.setPitch(c["pitch"]);
  await tts.setSpeechRate(c["rate"]);

  var voices = await tts.getVoices;

  var selectedVoice;

  if (selectedCompanion == "luna") {
    selectedVoice = voices.firstWhere(
      (v) => v['name'].toString().toLowerCase().contains("female") ||
             v['name'].toString().toLowerCase().contains("samantha"),
      orElse: () => voices.first,
    );
  } else {
    selectedVoice = voices.firstWhere(
      (v) => v['name'].toString().toLowerCase().contains("male"),
      orElse: () => voices.last,
    );
  }

  await tts.setVoice({
    "name": selectedVoice['name'],
    "locale": selectedVoice['locale'],
  });
}

  Future<void> initSpeech() async {
  await Permission.microphone.request();

  bool available = await speech.initialize();

  if (!available) {
    print("Speech not available");
  }
}


void startListening() async {
  bool available = await speech.initialize();

  if (available) {
    setState(() => isListening = true);

    speech.listen(onResult: (result) {
      setState(() {
        userText = result.recognizedWords;
        _controller.text = userText;
      });
    });
  }
}



void stopListening() async {
  await speech.stop();

  setState(() => isListening = false);

  if (_controller.text.isNotEmpty) {
    await sendMessageFromVoice(_controller.text);
  }
}

 
Future<void> sendMessage() async {
  if (_controller.text.isEmpty) return;

  String text = _controller.text;
  _controller.clear();

  setState(() {
    lastMessage = text;
    avatarExpression = "thinking";
  });

  try {
    String aiResponse = await getAIResponse(text);

    setState(() {
      avatarExpression = "talking";
    });

    await applyVoiceStyle();
    await tts.speak(aiResponse);

  } catch (e) {
    await tts.speak("Something went wrong. Try again.");
  }

  setState(() {
    avatarExpression = "neutral";
  });
}




  // 🤖 Companion response system
 /* String getResponse(String userText) {
    if (selectedCompanion == "luna") {
      return "🌙 Luna: I hear you. You don’t have to go through this alone. Take your time.";
    } else {
      return "☀️ Kai: I’ve got you. Let’s break this down step by step. You’re stronger than this.";
    }
  }*/

  String getResponse(String userText) {
  String text = userText.toLowerCase();

  if (selectedCompanion == "luna") {
    return lunaPersonality(text);
  } else {
    return kaiPersonality(text);
  }
}

String lunaPersonality(String text) {
  if (text.contains("sad") || text.contains("tired")) {
    avatarExpression = "sad";
    return "Hey… I feel that. You don’t have to carry everything alone 💜";
  }

  if (text.contains("angry")) {
    avatarExpression = "calm";
    return "Let’s slow down together… breathe in… and out 🌙";
  }

  if (text.contains("happy")) {
    avatarExpression = "happy";
    return "That makes me so happy for you ✨ stay in that moment";
  }

  avatarExpression = "neutral";
  return "Talk to me… I’m here, always 🌙";
}

String kaiPersonality(String text) {
  if (text.contains("sad") || text.contains("tired")) {
    avatarExpression = "serious";
    return "Alright… tough moment. But you’re not stuck here. We move forward 💪";
  }

  if (text.contains("angry")) {
    avatarExpression = "focused";
    return "Don’t react yet. Control it first. Then decide ⚡";
  }

  if (text.contains("happy")) {
    avatarExpression = "excited";
    return "That’s what I’m talking about 🔥 keep that energy!";
  }

  avatarExpression = "neutral";
  return "Say what’s on your mind. Let’s figure it out.";
}



/* void sendMessage() async {
  if (_controller.text.isEmpty) return;

  String userText = _controller.text;
  _controller.clear();

  setState(() {
    lastMessage = userText;
    avatarExpression = "thinking";
  });

  await Future.delayed(const Duration(milliseconds: 600));

  String response = getResponse(userText);

  setState(() {});

  await applyVoiceStyle(); // 👈 VERY IMPORTANT

  await tts.speak(response);

  setState(() {
    avatarExpression = "neutral";
  });
}*/
   

  // 🎭 Safe avatar widget
  Widget avatarWidget() {
    return Image.asset(
      "assets/avatar_$avatarExpression.png",
      width: 160,
      height: 160,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(
          Icons.emoji_emotions,
          size: 120,
          color: Colors.white,
        );
      },
    );
  }

  // 🌙☀️ Companion selector
  Widget companionSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: const Text("🌙 Luna"),
          selected: selectedCompanion == "luna",
          onSelected: (val) {
            setState(() => selectedCompanion = "luna");
          },
        ),
        const SizedBox(width: 10),
        ChoiceChip(
          label: const Text("☀️ Kai"),
          selected: selectedCompanion == "kai",
          onSelected: (val) {
            setState(() => selectedCompanion = "kai");
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[900],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              const Text(
                "AI Companion Chat",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              companionSelector(),

              const SizedBox(height: 20),

              avatarWidget(),

              const SizedBox(height: 20),

              if (lastMessage.isNotEmpty)
                Text(
                  "You: $lastMessage",
                  style: const TextStyle(color: Colors.white70),
                ),

              const Spacer(),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Talk to Luna or Kai...",
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.white12,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),

                  ),
                  IconButton(
  icon: Icon(
    isListening ? Icons.mic_off : Icons.mic,
    color: Colors.white,
    size: 28,
  ),
  onPressed: () {
    if (isListening) {
      stopListening();
    } else {
      startListening();
    }
  },
),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: sendMessage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    child: const Icon(Icons.send),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}