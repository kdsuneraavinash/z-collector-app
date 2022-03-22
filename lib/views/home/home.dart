import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:z_collector_app/views/home/lists.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Z- Collector"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomeProjectList(
              title: "My Projects",
              path: '/home/list/project/my',
              query: FirebaseFirestore.instance
                  .collection('projects')
                  .where('isPrivate', isNotEqualTo: true)
                  .get(),
            ),
            const SizedBox(height: 8),
            HomeProjectList(
              title: "Private Projects",
              path: '/home/list/project/private',
              query: FirebaseFirestore.instance
                  .collection('projects')
                  .where('isPrivate', isNotEqualTo: true)
                  .get(),
            ),
            const SizedBox(height: 8),
            HomeProjectList(
              title: "Public Projects",
              path: '/home/list/project/public',
              max: 3,
              query: FirebaseFirestore.instance
                  .collection('projects')
                  .where('isPrivate', isNotEqualTo: false)
                  .get(),
            ),
          ],
        ),
      ),
    );
  }
}
