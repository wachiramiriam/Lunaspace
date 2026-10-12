import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'banned.dart';
import 'register.dart';
import 'admin_dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginUser(
  String email,
  String password,
  BuildContext context,
) async {
  try {
    // 1. Login user
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final uid = userCredential.user!.uid;

    // 2. Get user data from Firestore
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    final data = userDoc.data();

    if (data == null) {
      await FirebaseAuth.instance.signOut();
      return;
    }

    // 3. Check if banned
    if (data['isBanned'] == true) {
      await FirebaseAuth.instance.signOut();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BannedScreen()),
      );
      return;
    }

    // 4. ROLE-BASED ROUTING (🔥 MAIN FIX)
    String role = data['role'] ?? 'user';

    if (role == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminDashboard()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }

  } catch (e) {
    print("Login error: $e");
  }
}

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            SizedBox(height: 10),

            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: (){
                loginUser(_emailController.text.trim(),
                 _passwordController.text.trim(), 
                 context);
              },
              child: const Text("Login"),
            ),

            SizedBox(height: 10),

            TextButton(
              onPressed: () {
                 Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
              },
              child: const Text("Don't have an account? Register"),
            )
          ],
        ),
      ),
    );
  }
}