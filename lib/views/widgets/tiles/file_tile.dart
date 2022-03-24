import 'package:flutter/material.dart';
import 'package:z_collector_app/models/project.dart';

class RecordFileFieldTile extends StatelessWidget {
  final ProjectField field;
  final dynamic value;

  const RecordFileFieldTile(
      {Key? key, required this.field, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    if (value is! String) {
      return ListTile(
        title: const Text("File Not Set"),
        subtitle: Text(field.name),
      );
    }

    return ListTile(
      title: Text(field.name),
      subtitle: const Text("Tap to open"),
      trailing: const Icon(Icons.open_in_browser),
      onTap: () {
        // TODO: Open in browser
      },
    );
  }
}
