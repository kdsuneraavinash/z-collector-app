import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Z- Collector"),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("Logout"),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.popAndPushNamed(context, '/login');
          },
        ),
      ),
    );
  }
}
