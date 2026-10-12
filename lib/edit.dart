import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final String currentName;
  final String currentEmail;

  const EditProfilePage({super.key, required this.currentName, required this.currentEmail});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentName);
    emailController = TextEditingController(text: widget.currentEmail);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile'), backgroundColor: Colors.purple),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Pass data back
                Navigator.pop(context, {
                  'name': nameController.text,
                  'email': emailController.text,
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              child: const Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}