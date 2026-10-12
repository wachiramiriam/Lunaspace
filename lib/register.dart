import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    
    super.initState();

  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

Future<void> registeruser(
  BuildContext context,
  String email,
  String password,
) async {
  try {
    // 1. Create Auth user
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final user = userCredential.user;

    if (user == null) return;

    // 2. Create Firestore profile
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': email.trim(),
      'name': email.split('@')[0],

      // 🔥 ROLE SYSTEM (IMPORTANT)
      'role': 'user', // default role

      // future-proof flags
      'isBanned': false,
      'isVerified': false,

      'createdAt': FieldValue.serverTimestamp(),
    });

    // 3. Navigate to login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  } catch (e) {
    print("Registration error: $e");
  }
}

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    registeruser(
                      context, 
                      _emailController.text.trim(), 
                      _passwordController.text.trim()
                    );
                  },
                   
                  child: const Text("Register"),
                ),
                ElevatedButton(
                  onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                  },
                  child: const Text("Already have an account? Login"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}