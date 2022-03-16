import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:z_collector_app/models/project.dart';
import 'package:z_collector_app/models/user.dart';
import 'package:z_collector_app/views/helpers/firebase_builders.dart';

class DetailProjectPage extends StatelessWidget {
  final String projectId;

  const DetailProjectPage({Key? key, required this.projectId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Project Details')),
      body: FirebaseUserStreamBuilder(
        builder: (context, currentUserId) => FirestoreStreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('projects')
              .doc(projectId)
              .snapshots(),
          builder: (context, projectMap) {
            final project = Project.fromJson(projectMap);
            return FirestoreStreamBuilder(
              stream: project.owner.snapshots(),
              builder: (context, userMap) => DetailProjectView(
                projectId: projectId,
                project: project,
                owner: User.fromJson(userMap),
                currentUserId: currentUserId,
              ),
            );
          },
        ),
      ),
    );
  }
}

class DetailProjectView extends StatelessWidget {
  final String projectId;
  final Project project;
  final User owner;
  final String currentUserId;

  const DetailProjectView({
    Key? key,
    required this.projectId,
    required this.project,
    required this.owner,
    required this.currentUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuerySize = MediaQuery.of(context).size;
    final isOwner = currentUserId == project.owner.id;
    // TODO: Complete this screen.

    return ListView(
      children: [
        Stack(
          children: [
            Image.network(
              project.imageUrl ?? "https://via.placeholder.com/200x200",
              fit: BoxFit.cover,
              color: Colors.black.withAlpha(127),
              colorBlendMode: BlendMode.srcOver,
              width: mediaQuerySize.width,
            ),
            Positioned(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  project.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                  ),
                ),
              ),
              bottom: 0,
              left: 0,
            )
          ],
        ),
        ListTile(
          title: Text(owner.name),
          subtitle: const Text('Project Owner'),
          leading: const Icon(Icons.shield),
        ),
        ListTile(
          title: Text(project.isPrivate ? 'Private' : 'Public'),
          subtitle: const Text('Project Visibility'),
          leading: const Icon(Icons.visibility),
        ),
        if (isOwner)
          ListTile(
            title: Text(project.isPublished ? 'Published' : 'Draft'),
            subtitle: const Text('Project Status'),
            leading: const Icon(Icons.public),
          ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(project.description),
        ),
        if (isOwner)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: const Text("Show All Records"),
              onPressed: () {
                Beamer.of(context).beamToNamed(
                    '/home/project/k5KTXwyilMpQDH28w3An/record/list');
              },
            ),
          ),
      ],
    );
  }
}
