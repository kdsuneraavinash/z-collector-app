import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:z_collector_app/models/project.dart';
import 'package:z_collector_app/views/helpers/firebase_builders.dart';
import 'package:z_collector_app/views/home/home.dart';

class ListMyProjects extends StatelessWidget {
  const ListMyProjects({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return ListProjects(
      title: 'My Projects',
      query: FirebaseFirestore.instance
          .collection('projects')
          .where('owner', isEqualTo: uid)
          .get(),
    );
  }
}

class ListPrivateProjects extends StatelessWidget {
  const ListPrivateProjects({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListProjects(
      title: 'Private Projects',
      query: FirebaseFirestore.instance
          .collection('projects')
          .where('isPrivate', isNotEqualTo: false)
          .get(),
    );
  }
}

class ListPublicProjects extends StatelessWidget {
  const ListPublicProjects({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListProjects(
      title: 'Public Projects',
      query: FirebaseFirestore.instance
          .collection('projects')
          .where('isPrivate', isNotEqualTo: false)
          .get(),
    );
  }
}

class ListProjects extends StatelessWidget {
  final String title;
  final Future<QuerySnapshot<Map<String, dynamic>>> query;

  const ListProjects({Key? key, required this.title, required this.query})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: FirestoreTBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: query,
          builder: (context, snapshot) {
            final items = snapshot.docs.map((doc) {
              final proj = Project.fromJson(doc.data());
              return ProjectCard(
                  title: proj.name,
                  description: proj.description,
                  imageUrl: proj.imageUrl,
                  projectId: '');
            }).toList();

            return Column(
              children: items,
            );
          },
        ),
      ),
    );
  }
}
