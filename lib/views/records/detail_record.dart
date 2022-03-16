import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:z_collector_app/models/project.dart';
import 'package:z_collector_app/models/record.dart';
import 'package:z_collector_app/models/user.dart';
import 'package:z_collector_app/views/helpers/firebase_builders.dart';
import 'package:timeago/timeago.dart' as timeago;

class DetailRecordPage extends StatelessWidget {
  final String projectId;
  final String recordId;

  const DetailRecordPage(
      {Key? key, required this.projectId, required this.recordId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get current user
    return FirebaseUserStreamBuilder(
      builder: (context, currentUserId) {
        final projectRef =
            FirebaseFirestore.instance.collection('projects').doc(projectId);
        final recordRef =
            FirebaseFirestore.instance.collection('records').doc(recordId);

        // Get project
        return FirestoreStreamBuilder(
          stream: projectRef.snapshots(),
          builder: (context, projectMap) {
            final project = Project.fromJson(projectMap);

            // Scaffold wrapper
            return Scaffold(
              appBar: AppBar(
                title: const Text('Record Details'),
              ),
              // Guard for user is owner
              body: FirestoreStreamBuilder(
                stream: recordRef.snapshots(),
                builder: (context, recordMap) {
                  final record = Record.fromJson(recordMap);

                  // User of record
                  return FirestoreStreamBuilder(
                    stream: record.user.snapshots(),
                    builder: (context, userMap) => DetailRecordView(
                      project: project,
                      record: record,
                      recordId: recordId,
                      currentUserId: currentUserId,
                      user: User.fromJson(userMap),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class DetailRecordView extends StatelessWidget {
  final Project project;
  final String recordId;
  final Record record;
  final User user;
  final String currentUserId;

  const DetailRecordView({
    Key? key,
    required this.project,
    required this.recordId,
    required this.record,
    required this.user,
    required this.currentUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuerySize = MediaQuery.of(context).size;
    final isOwner = currentUserId == project.owner.id;
    final fieldHeaders = project.fieldHeaders();
    final fieldValues = record.fieldValues();
    final items = min(fieldHeaders.length, fieldValues.length);
    final timeagoMsg = timeago.format(record.timestamp.toDate());

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.numbers),
          title: Text(recordId),
          subtitle: const Text("Record ID"),
        ),
        ListTile(
          leading: const Icon(Icons.account_circle),
          title: Text("${user.name} (${user.email})"),
          subtitle: const Text("Recorded by"),
        ),
        ListTile(
          leading: const Icon(Icons.timer),
          title: Text("${record.timestamp.toDate().toString()} ($timeagoMsg)"),
          subtitle: const Text("Recorded at"),
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: items,
            itemBuilder: (context, index) => ListTile(
              title: Text(fieldValues[index]),
              subtitle: Text(fieldHeaders[index]),
            ),
          ),
        ),
      ],
    );
  }
}
