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
    // Get current user
    return FirebaseUserStreamBuilder(
      builder: (context, currentUserId) {
        final projectRef =
            FirebaseFirestore.instance.collection('projects').doc(projectId);

        // Get project
        return FirestoreStreamBuilder(
          stream: projectRef.snapshots(),
          builder: (context, projectMap) {
            final project = Project.fromJson(projectMap);

            // Scaffold wrapper
            return Scaffold(
              appBar: AppBar(
                title: const Text('Record List'),
                actions: [
                  IconButton(
                      onPressed: () => _downloadRecords(projectRef, project),
                      icon: const Icon(Icons.download))
                ],
              ),
              // Guard for user is owner
              body: (currentUserId == project.owner.id)
                  // Records of project
                  ? FirestoreQueryStreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('records')
                          .where('project', isEqualTo: projectRef)
                          .snapshots(),
                      builder: (context, recordId, recordMap) {
                        final record = Record.fromJson(recordMap);

                        // User of each record
                        return FirestoreStreamBuilder(
                          stream: record.user.snapshots(),
                          builder: (context, userMap) => ListRecordView(
                            project: project,
                            record: record,
                            recordId: recordId,
                            currentUserId: currentUserId,
                            user: User.fromJson(userMap),
                          ),
                        );
                      },
                    )
                  : Container(),
            );
          },
        );
      },
    );
  }

  void _downloadRecords(DocumentReference projectRef, Project project) async {
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
  final Project project;
  final String recordId;
  final Record record;
  final User user;
  final String currentUserId;

  const ListRecordView({
    Key? key,
    required this.project,
    required this.recordId,
    required this.record,
    required this.user,
    required this.currentUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Record $recordId"),
      subtitle: Text("Added by ${user.name} (${user.email})"),
      trailing:
          Text(timeago.format(record.timestamp.toDate(), locale: "en_short")),
      onTap: () {},
    );
  }
}
