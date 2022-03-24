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
    final items = min(project.fields.length, record.fields.length);
    final timeagoMsg = timeago.format(record.timestamp.toDate());

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.card_membership),
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
            itemBuilder: (context, index) => RecordFieldTile(
              field: project.fields[index],
              value: record.fields[index],
            ),
          ),
        ),
      ],
    );
  }
}

class RecordFieldTile extends StatelessWidget {
  final ProjectField field;
  final dynamic value;

  const RecordFieldTile({Key? key, required this.field, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    if (field.type == ProjectFieldType.location) {
      if (value is GeoPoint) {
        return ListTile(
            title: Text("${value.longitude}, ${value.latitude}"),
            subtitle: Text(field.name),
            leading: const Icon(Icons.map),
            trailing: const Icon(Icons.open_in_browser),
            onTap: () {
              // TODO: Open in google maps
            });
      }
    }

    if (field.type == ProjectFieldType.boolean) {
      final selected = value == "true";
      return ListTile(
        title: Text(field.name),
        subtitle: Text(selected ? "Yes" : "No"),
        leading: Icon(selected ? Icons.check : Icons.close),
      );
    }

    if (field.type == ProjectFieldType.date ||
        field.type == ProjectFieldType.dateTime ||
        field.type == ProjectFieldType.time) {
      if (value is Timestamp) {
        // TODO: Hide date if time or time if date type
        return ListTile(
          title: Text(value.toDate().toString()),
          subtitle: Text(field.name),
          leading: const Icon(Icons.event),
        );
      }
    }

    if (field.type == ProjectFieldType.video ||
        field.type == ProjectFieldType.audio ||
        field.type == ProjectFieldType.image) {
      return ListTile(
          title: Text(field.name),
          leading: const Icon(Icons.attach_file),
          trailing: const Icon(Icons.open_in_browser),
          onTap: () {
            // TODO: Open in browser
          });
    }

    if (field.type == ProjectFieldType.locationSeries) {
      return buildTable(context,
          title: field.name,
          columns: ["Time", "Longitude", "Latitude"],
          data: value.toString().split(",").map((e) => e.split("|")).toList());
    }

    return ListTile(
      title: Text(value.toString()),
      subtitle: Text(field.name),
      leading: Icon(
        field.type == ProjectFieldType.numeric
            ? Icons.one_k
            : field.type == ProjectFieldType.radio ||
                    field.type == ProjectFieldType.dropdown
                ? Icons.select_all
                : field.type == ProjectFieldType.checkBoxes
                    ? Icons.mp_outlined
                    : Icons.description,
      ),
    );
  }

  Widget buildTable(BuildContext context,
      {required String title,
      required List<String> columns,
      required List<List<String>> data}) {
    return Column(
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyText2),
        DataTable(
          columns: [
            for (int i = 0; i < columns.length; i++)
              DataColumn(label: Text(columns[i]))
          ],
          rows: [
            for (int i = 0; i < data.length; i++)
              DataRow(cells: [
                DataCell(Text(extractTime(DateTime.tryParse(data[i][0])))),
                DataCell(Text(data[i][1])),
                DataCell(Text(data[i][2]))
              ])
          ],
        ),
      ],
    );
  }

  String extractTime(DateTime? timestamp) {
    final timestampVal = timestamp;
    if (timestampVal == null) return "";
    return "${timestampVal.hour}:${timestampVal.minute}:${timestampVal.second}";
  }
}
