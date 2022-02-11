import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Z- Collector"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              child: const Text("Project Details"),
              onPressed: () {
                Beamer.of(context)
                    .beamToNamed('/home/project/k5KTXwyilMpQDH28w3An');
              },
            ),
            ElevatedButton(
              child: const Text("Add Record"),
              onPressed: () {
                Beamer.of(context).beamToNamed(
                    '/home/project/k5KTXwyilMpQDH28w3An/record/add');
              },
            ),
            ElevatedButton(
              child: const Text("Logout"),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Beamer.of(context).beamToNamed('/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
