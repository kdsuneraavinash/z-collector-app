import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:z_collector_app/models/project.dart';
import 'package:z_collector_app/models/user.dart';
import 'package:z_collector_app/views/helpers/dynamic_links.dart';
import 'package:z_collector_app/views/helpers/firebase_builders.dart';
import 'package:z_collector_app/views/helpers/is_allowed.dart';
import 'package:z_collector_app/views/widgets/storage_image.dart';

class DetailProjectPage extends StatelessWidget {
  final String projectId;

  const DetailProjectPage({Key? key, required this.projectId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FirebaseUserStreamBuilder(
      builder: (context, currentUserId) => FirestoreStreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('projects')
            .doc(projectId)
            .snapshots(),
        builder: (context, projectMap) {
          final project = Project.fromJson(projectMap);
          final userRef =
              FirebaseFirestore.instance.collection('users').doc(currentUserId);
          final recordAllowed = isAllowedToAddRecord(userRef, project);
          final viewAllowed = isAllowedToView(userRef, project);
          return Scaffold(
            appBar: AppBar(title: const Text('Project Details')),
            body: viewAllowed
                ? FirestoreStreamBuilder(
                    stream: project.owner.snapshots(),
                    builder: (context, userMap) => DetailProjectView(
                      projectId: projectId,
                      project: project,
                      owner: User.fromJson(userMap),
                      currentUserId: currentUserId,
                    ),
                  )
                : PrivateProjectEntryPage(
                    project: project,
                    projectId: projectId,
                    currentUserId: currentUserId,
                  ),
            floatingActionButton: recordAllowed
                ? FloatingActionButton.extended(
                    onPressed: () {
                      Beamer.of(context)
                          .beamToNamed('/home/project/$projectId/record/add');
                    },
                    label: const Text("Add Record"),
                    icon: const Icon(Icons.add),
                  )
                : null,
          );
        },
      ),
    );
  }
}

class PrivateProjectEntryPage extends StatelessWidget {
  final String projectId;
  final Project project;
  final String currentUserId;

  const PrivateProjectEntryPage(
      {Key? key,
      required this.project,
      required this.projectId,
      required this.currentUserId})
      : super(key: key);

  Future<void> _addPrivateProject(String text) async {
    if (text == project.entryCode!) {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(currentUserId);
      final projectRef =
          FirebaseFirestore.instance.collection('projects').doc(projectId);
      final userMap = (await userRef.get()).data();
      final user = User.fromJson(userMap!);

      user.allowedPrivateProjects.add(projectRef);
      project.allowedUsers.add(userRef);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .update(user.toJson());

      await FirebaseFirestore.instance
          .collection('projects')
          .doc(projectId)
          .update(project.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: OTPTextField(
              length: 5,
              width: MediaQuery.of(context).size.width * .8,
              fieldWidth: 50,
              style: const TextStyle(fontSize: 17),
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldStyle: FieldStyle.box,
              onCompleted: _addPrivateProject,
              onChanged: (String _) {},
            ),
          ),
          const Text('Enter Entry Code')
        ]),
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
    final isOwner = currentUserId == project.owner.id;

    void _showShareDialog() async {
      final uri = await getPrivateProjectDynamicLink(projectId);
      await FlutterShare.share(
          title: "Project Invite", linkUrl: uri.toString());
    }

    return ListView(
      children: [
        Stack(
          children: [
            StorageImage(storageUrl: project.imageUrl),
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
          padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
          child: Text(project.description),
        ),
        if (isOwner)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton(
              child: const Text("Show All Records"),
              onPressed: () {
                Beamer.of(context)
                    .beamToNamed('/home/project/$projectId/records');
              },
            ),
          ),
        if (isOwner && project.isPublished)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton.icon(
              label: const Text("Share Project"),
              icon: const Icon(Icons.share),
              onPressed: _showShareDialog,
              style: ElevatedButton.styleFrom(primary: Colors.green),
            ),
          ),
        if (isOwner && !project.isPublished)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton.icon(
              label: const Text("Publish Project"),
              icon: const Icon(Icons.publish),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('projects')
                    .doc(projectId)
                    .update({'isPublished': true});
              },
              style: ElevatedButton.styleFrom(primary: Colors.green),
            ),
          ),
        if (isOwner)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton(
              child: const Text("Blacklist/Allow Users"),
              onPressed: () => Beamer.of(context)
                  .beamToNamed('/home/project/$projectId/blacklisted'),
              style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
            ),
          ),
        const SizedBox(height: 72),
      ],
    );
  }
}
