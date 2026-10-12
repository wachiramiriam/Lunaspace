import 'package:flutter/material.dart';
import 'edit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

String userName = 'Phoenix';
String userEmail = 'phoenix@email.com';

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.purple[100],
              child: const Icon(Icons.person, size: 50, color: Colors.purple),
            ),
            const SizedBox(height: 15),

            // Name
            Text(
              userName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 5),
            Text(
              userEmail,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            // Profile options / stats
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                leading: const Icon(Icons.edit, color: Colors.purple),
                title: const Text('Edit Profile'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditProfilePage(
        currentName: userName,
        currentEmail: userEmail,
      ),
    ),
  );

  if (result != null) {
    setState(() {
      userName = result['name'];
      userEmail = result['email'];
    });
  }
},
              ),
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                leading: const Icon(Icons.settings, color: Colors.purple),
                title: const Text('Settings'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to settings page
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Log Out', style: TextStyle(color: Colors.red)),
                onTap: () {
                  // Handle log out
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}