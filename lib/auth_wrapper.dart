import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'role_service.dart';
import 'main.dart';
import 'admin_dashboard.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool loading = true;
  Widget? nextScreen;

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  Future<void> checkUser() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() {
        nextScreen = const Center(child: Text("Not logged in"));
        loading = false;
      });
      return;
    }

    final role = await RoleService.getUserRole();

    if (role == "admin") {
      nextScreen = const AdminDashboard();
    } else {
      nextScreen = const HomePage();
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return nextScreen!;
  }
}