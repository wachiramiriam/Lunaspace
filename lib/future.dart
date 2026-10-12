import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FutureLetterPage extends StatefulWidget {
  const FutureLetterPage({super.key});

  @override
  State<FutureLetterPage> createState() => _FutureLetterPageState();
}

class _FutureLetterPageState extends State<FutureLetterPage> {
  final TextEditingController _controllerText = TextEditingController();
  DateTime? selectedDate;

  @override
  void dispose() {
    _controllerText.dispose();
    super.dispose();
  }

  Future<void> saveLetter() async {
  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("No user logged in");
      return;
    }

    final uid = user.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('futureLetters')
        .add({
      'letter': _controllerText.text.trim(),
      'unlockDate': Timestamp.fromDate(selectedDate!),
      'createdAt': Timestamp.now(),
    });

    print("Letter saved successfully");

  } catch (e) {
    print("Error saving letter: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Future Letter 💌")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 📝 Text input
            TextField(
              controller: _controllerText,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "Write to your future self...",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // 📅 Date picker button
            ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 30)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                );

                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              child: Text(
                selectedDate == null
                    ? "Select Unlock Date 📅"
                    : "Unlock on: ${selectedDate!.toLocal()}".split(' ')[0],
              ),
            ),

            const SizedBox(height: 20),

            //  Save button
            ElevatedButton(
              onPressed: () async {
                if (_controllerText.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please write a letter and select a date"),
                    ),
                  );
                  return;
                  }

                if (selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select a date"),
                    ),
                  );
                  return;
                }

                try {
                  await saveLetter();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Letter saved successfully! 💌"),
                    ),
                  );

                  _controllerText.clear();
                  setState(() {
                    selectedDate = null;
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e")),
                  );
                }
              },

              child: const Text("Save Letter 📩"),
            ),
          ],
        ),
      ),
    );
  }
}