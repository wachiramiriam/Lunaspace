import 'package:flutter/material.dart';
import 'package:soulscript/admin_dashboard.dart';
import 'package:soulscript/register.dart';
import 'journal.dart';
import 'profile.dart';
import 'insights.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegisterPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});



  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // track selected tab

  String? selectedMood;
  String userName = "User";



  List<Widget> get _pages => [
      HomeContent(
        onJournalTap:_switchToJournal,
        onMoodSelected: addMood, 
        userName: userName,
      ),
      const JournalPage(),
      InsightsPage(moods: moods), // pass moods to Insights
      const ProfilePage(), // Admin page
    ];

  List<double> moods = [6, 7, 5, 8, 7, 9, 4];


  void addMood(double moodValue) {
  setState(() {
    moods.add(moodValue);
    if (moods.length > 7) moods.removeAt(0);
  });
}

void _switchToJournal() {
  setState(() {
    _currentIndex = 1;
  }
  );
}


  @override
void initState() {
  super.initState();
  loadUserName();
}

Future<void> loadUserName() async {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get();

  setState(() {
    userName = doc['name'] ?? "User";
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.purpleAccent,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // switch tab
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journal'),
          BottomNavigationBarItem(icon: Icon(Icons.insights), label: 'Insights'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// This widget contains your LunaSpace header, mood buttons, and Start Journaling button
class HomeContent extends StatefulWidget {
  final VoidCallback onJournalTap;
  final Function(double) onMoodSelected;
  final String userName;

  const HomeContent({super.key, 
  required this.onJournalTap,
  required this.onMoodSelected,
  required this.userName});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String? selectedMood;

  final TextEditingController _controllerText = TextEditingController();

    String getTodayId() {
  final now = DateTime.now();
  return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  Future<void> saveReflection(String mood) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception("User not logged in");
  }

  final dateId = getTodayId();

  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('reflections')
      .doc(dateId)
      .set({
    'userId':  FirebaseAuth.instance.currentUser!.uid,
    'mood': selectedMood,
    'reflection': _controllerText.text.trim(),
    'createdAt': Timestamp.now(),
  });
}



  String getTimeGreeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return "Good morning, ${widget.userName} ☀️";
  if (hour < 17) return "Good afternoon, ${widget.userName} 🌤️";
  return "Good evening, ${widget.userName} 🌙";
}

  String getGreeting() {
  if (selectedMood == "😔 Sad") {
    return "I'm here for you, ${widget.userName} 💜";
  } else if (selectedMood == "😢 Overwhelmed") {
    return "Take a breath… one step at a time 🌿";
  } else if (selectedMood == "😠 Angry") {
    return "It's okay to feel this way. Let's slow it down 🔥";
  } else if (selectedMood == "😊 Peaceful") {
    return "Glad you're feeling peaceful 🌙";
  } else if (selectedMood == "🙂 Okay") {
    return "A calm day is still a good day ✨";
  } else if (selectedMood == "😐 Neutral") {
    return "Let's find something meaningful today 🌱";
  } else {
    return "Good evening, ${widget.userName} 🌙";
  }
}


Color getMoodColor() {
  switch (selectedMood) {
    case "😊 Peaceful":
      return Colors.green.shade200;
    case "🙂 Okay":
      return Colors.blue.shade200;
    case "😐 Neutral":
      return Colors.grey.shade300;
    case "😔 Sad":
      return Colors.indigo.shade200;
    case "😢 Overwhelmed":
      return Colors.deepPurple.shade200;
    case "😠 Angry":
      return Colors.red.shade200;
    default:
      return Colors.white;
  }
}

// initial 7 moods

  @override
@override
Widget build(BuildContext context) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 500),
    color: getMoodColor(),
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFDCC6F0),
                  Color(0xFFF5E6DA),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite, color: Colors.purple, size: 28),
                const SizedBox(width: 8),
                Text(
                  'LunaSpace',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.purple[800],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 50),
        

        AnimatedSwitcher(
  duration: const Duration(milliseconds: 300),
  child: Text(
    selectedMood != null
        ? getGreeting()
        : "${getTimeGreeting()}, ${widget.userName} 🌙",
    key: ValueKey(widget.userName),
    style: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
  ),
),

          const SizedBox(height: 5),

          if (selectedMood == null) ...[
            const Text(
              "How are you feeling today?",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
          ],

          const SizedBox(height: 20),

          // MOOD BUTTONS
          Wrap(
            spacing: 30,
            runSpacing: 20,
            children: [
              feelingButton("😊 Peaceful"),
              feelingButton("😀 Happy"),
              feelingButton("😐 Neutral"),
              feelingButton("😔 Sad"),
              feelingButton("😢 Overwhelmed"),
              feelingButton("😠 Angry"),
            ],
          ),

          const SizedBox(height: 20),

          // START JOURNAL BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  selectedMood == null ? null : widget.onJournalTap,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color.fromARGB(255, 135, 97, 241),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "✒️ Start Journaling",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // REFLECTION CARD
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Today's Reflection",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "What moment today made you pause and think?",
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: _controllerText, // ✅ FIXED
                    decoration: const InputDecoration(
                      hintText: "I'm here to listen...",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () async {
                      if (_controllerText.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text("Write your reflection first")),
                        );
                        return;
                      }

                      try {
                        await saveReflection(selectedMood ?? "Unknown");

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "Today's reflection saved 🌤")),
                        );

                        _controllerText.clear();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: $e")),
                        );
                      }
                    },
                    child: const Text("Save Reflection"),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}

 
Widget feelingButton(String mood) {
  final isSelected = selectedMood == mood;

  return GestureDetector(
    onTap: () {
      setState(() {
        selectedMood = mood;

        // Convert mood to a number (1–10)
        double moodValue;
        switch (mood) {
          case "😊 Peaceful":
            moodValue = 9;
            break;
          case "😀 Happy":
            moodValue = 7;
            break;
          case "😐 Neutral":
            moodValue = 5;
            break;
          case "😔 Sad":
            moodValue = 4;
            break;
          case "😢 Overwhelmed":
            moodValue = 3;
            break;
          case "😠 Angry":
            moodValue = 2;
            break;
          default:
            moodValue = 5;
        }

        widget.onMoodSelected(moodValue); // Keep last 7
      });
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.purple : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        mood,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    ),
  );
}
}

  // Helper function for mood buttons
  /*ElevatedButton feelingButton(String text) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD1C4E9),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(text),
    );
  }*/

  
