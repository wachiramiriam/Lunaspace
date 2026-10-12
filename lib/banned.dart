import 'package:flutter/material.dart';

class BannedScreen extends StatelessWidget {
  const BannedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.block, size: 80, color: Colors.red),
            SizedBox(height: 20),
            Text(
              "You are banned from this app",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Contact admin for more information"),
          ],
        ),
      ),
    );
  }
}