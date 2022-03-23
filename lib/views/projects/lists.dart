import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:z_collector_app/models/project.dart';
import 'package:z_collector_app/views/helpers/firebase_builders.dart';
import 'package:z_collector_app/views/helpers/get_projects.dart';
import 'package:z_collector_app/views/projects/list_card.dart';

class ListMyProjects extends StatelessWidget {
  const ListMyProjects({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FirebaseUserStreamBuilder(
      builder: (context, currentUserId) => ListProjects(
        title: 'My Projects',
        query: getMyProjects(currentUserId),
      ),
    );
  }
}

class ListPrivateProjects extends StatelessWidget {
  const ListPrivateProjects({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FirebaseUserStreamBuilder(
      builder: (context, currentUserId) => ListProjects(
        title: 'Private Projects',
        query: getPrivateProjects(currentUserId),
      ),
    );
  }
}

class ListPublicProjects extends StatelessWidget {
  const ListPublicProjects({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListProjects(
      title: 'Public Projects',
      query: getPublicProjects(),
    );
  }
}

class ListProjects extends StatelessWidget {
  final String title;
  final Query<Map<String, dynamic>> query;

  const ListProjects({Key? key, required this.title, required this.query})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FirestoreQueryStreamBuilder(
          emptyWidget: const Padding(
            padding: EdgeInsets.all(8),
            child: Text("Nothing to show."),
          ),
          stream: query.snapshots(),
          builder: (context, projectId, projectMap) {
            final project = Project.fromJson(projectMap);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ProjectListCard(
                projectId: projectId,
                project: project,
              ),
            );
          },
        ),
      ),
    );
  }
}
