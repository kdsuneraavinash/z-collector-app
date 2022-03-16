import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:z_collector_app/models/project.dart';
import 'package:z_collector_app/models/record.dart';
import 'package:z_collector_app/models/user.dart';
import 'package:z_collector_app/views/helpers/firebase_builders.dart';
import 'package:timeago/timeago.dart' as timeago;

class ListRecordPage extends StatelessWidget {
  final String projectId;

  const ListRecordPage({Key? key, required this.projectId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record List'),
        actions: [
          IconButton(
            onPressed: _downloadRecords,
            icon: const Icon(Icons.download),
          )
        ],
      ),
      body: FirebaseUserStreamBuilder(
        builder: (context, currentUserId) {
          return FirestoreStreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('projects')
                .doc(projectId)
                .snapshots(),
            builder: (context, projectMap) {
              final project = Project.fromJson(projectMap);
              return FirestoreStreamBuilder(
                stream: project.owner.snapshots(),
                builder: (context, userMap) => ListRecordView(
                  projectId: projectId,
                  project: project,
                  owner: User.fromJson(userMap),
                  currentUserId: currentUserId,
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _downloadRecords() async {
    // Get project
    final projectRef =
        FirebaseFirestore.instance.collection('projects').doc(projectId);
    final projectData = await projectRef.get();
    final projectMap = projectData.data();
    if (projectMap == null) return;
    final project = Project.fromJson(projectMap);

    // Get records
    final queryResults = await FirebaseFirestore.instance
        .collection('records')
        .where('project', isEqualTo: projectRef)
        .get();
    final records = queryResults.docs.map((e) => Record.fromJson(e.data()));

    // CSV headers
    final headers = [
      "User ID",
      "Project ID",
      "Timestamp",
      ...project.fieldHeaders()
    ];
    // CSV data generator
    List<String> recordGen(Record record) => [
          record.user.id,
          record.project.id,
          record.timestamp.toDate().toIso8601String(),
          ...record.fieldValues()
        ];

    // Create CSV
    final csvData = [headers, ...records.map(recordGen).toList()];
    String csv = const ListToCsvConverter().convert(csvData);

    // TODO: Download file
    print(csv);
  }
}

class ListRecordView extends StatelessWidget {
  final String projectId;
  final Project project;
  final User owner;
  final String currentUserId;

  const ListRecordView({
    Key? key,
    required this.projectId,
    required this.project,
    required this.owner,
    required this.currentUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOwner = currentUserId == project.owner.id;
    if (!isOwner) return Container();

    final projectRef =
        FirebaseFirestore.instance.collection('projects').doc(projectId);

    return FirestoreQueryStreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('records')
          .where('project', isEqualTo: projectRef)
          .snapshots(),
      builder: (context, id, recordMap) {
        final record = Record.fromJson(recordMap);
        return FirestoreStreamBuilder(
          stream: record.user.snapshots(),
          builder: (context, userMap) {
            final user = User.fromJson(userMap);

            return ListTile(
              title: Text("Record $id"),
              subtitle: Text("Added by ${user.name} (${user.email})"),
              trailing: Text(timeago.format(record.timestamp.toDate(),
                  locale: "en_short")),
              onTap: () {},
            );
          },
        );
      },
    );
  }
}
