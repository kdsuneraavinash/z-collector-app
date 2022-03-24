import 'package:flutter/material.dart';
import 'package:z_collector_app/models/project.dart';

class RecordTableFieldTile extends StatelessWidget {
  final ProjectField field;
  final List<String> columnNames;
  final dynamic value;

  const RecordTableFieldTile(
      {Key? key,
      required this.field,
      required this.columnNames,
      required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    if (value is! String) {
      return ListTile(
        title: const Text("Data Not Set"),
        subtitle: Text(field.name),
      );
    }

    final data = value.split(",").map((e) => e.split("|")).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(field.name,
              style: TextStyle(
                color: Theme.of(context).textTheme.caption?.color,
              )),
        ),
        DataTable(
          columns: [
            for (int i = 0; i < columnNames.length; i++)
              DataColumn(label: Text(columnNames[i]))
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
