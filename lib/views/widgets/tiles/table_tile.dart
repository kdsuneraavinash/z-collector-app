import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
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
                  for (int j = 1; j < columnNames.length; j++)
                    if (data[i].length < j + 1)
                      const DataCell(Text(""))
                    else
                      DataCell(Text(data[i][j]))
                ])
            ],
          ),
        ],
      ),
    );
  }

  String extractTime(DateTime? timestamp) {
    final timestampVal = timestamp;
    if (timestampVal == null) return "";
    return DateFormat('kk:mm:ss').format(timestampVal);
  }
}
