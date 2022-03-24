import 'package:flutter/material.dart';
import 'package:z_collector_app/models/project.dart';

class RecordBooleanFieldTile extends StatelessWidget {
  final ProjectField field;
  final bool value;

  const RecordBooleanFieldTile(
      {Key? key, required this.field, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(field.name),
      subtitle: Text(value ? "Yes" : "No"),
      trailing: Icon(value ? Icons.check : Icons.close),
    );
  }
}
