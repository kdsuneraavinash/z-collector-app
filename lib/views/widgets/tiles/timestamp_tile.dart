import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:z_collector_app/models/project.dart';

class RecordTimestampFieldTile extends StatelessWidget {
  final ProjectField field;
  final dynamic value;

  const RecordTimestampFieldTile(
      {Key? key, required this.field, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    if (value is! Timestamp) {
      return ListTile(
        title: const Text("Date/Time Not Set"),
        subtitle: Text(field.name),
      );
    }

    // TODO: Hide date if time or time if date type
    return ListTile(
      title: Text(value.toDate().toString()),
      subtitle: Text(field.name),
    );
  }
}
