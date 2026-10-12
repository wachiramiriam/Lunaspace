import 'package:flutter/material.dart';
import 'release.dart';
import 'luna.dart';
import 'future.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});
  

  @override
  State<JournalPage> createState() => _JournalPageState();

}

class _JournalPageState extends State<JournalPage> {
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerText = TextEditingController();


  String? selectedMood;

  @override
  void dispose() {
    _controllerTitle.dispose();
    _controllerText.dispose();
    super.dispose();
  }


Future<void> saveJournal() async {
  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("No user logged in");
      return;
    }

    await FirebaseFirestore.instance
        .collection('journals')
        .add({
      'userId': user.uid,
      'title': _controllerTitle.text.trim(),
      'content': _controllerText.text.trim(),
      'mood': selectedMood,
      'createdAt': Timestamp.now(),
    });

    print("Journal saved successfully");

  } catch (e) {
    print("Error saving journal: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Daily Journal'),
      ),

       drawer: Drawer(
    backgroundColor: Colors.deepPurpleAccent,
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent,
          ),
          child: Text(
            'LunaSpace',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        ListTile(
          leading: Icon(Icons.emoji_emotions, color: Colors.white),
          title: Text('Talk to Luna', style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => AvatarChatPage()));
          },
        ),
        ListTile(
          leading: Icon(Icons.flight_takeoff, color: Colors.white),
          title: Text('Secret Chamber', style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => ReleasePage()));
          },
        ),

        ListTile(
          leading: Icon(Icons.emoji_emotions, color: Colors.white),
          title: Text('Letter To Future', style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => FutureLetterPage()));
          },
        ),
      ],
    ),
  ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How are you feeling today? 😊',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: TextField(
                controller: _controllerText,
                maxLines: 8,
                decoration: InputDecoration(
                  labelText: 'Write down how you feel today',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                  ),
                  child: const Text(
                    "Save Draft",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),

                ElevatedButton(
  onPressed: () async {
    if (_controllerText.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please write something before publishing!")),
      );
      return;
    }

    await saveJournal();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Journal saved successfully!")),
    );

    _controllerTitle.clear();
    _controllerText.clear();
  },
  child: Text("Publish"),
),
              ],
            ),
           
          ],
        ),
      ),
    );
  }
}