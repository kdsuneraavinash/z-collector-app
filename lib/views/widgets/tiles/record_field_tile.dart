import 'package:flutter/material.dart';
import 'package:z_collector_app/models/project.dart';
import 'package:z_collector_app/views/widgets/tiles/boolean_tile.dart';
import 'package:z_collector_app/views/widgets/tiles/file_tile.dart';
import 'package:z_collector_app/views/widgets/tiles/geo_point_tile.dart';
import 'package:z_collector_app/views/widgets/tiles/multiple_value_tile.dart';
import 'package:z_collector_app/views/widgets/tiles/table_tile.dart';
import 'package:z_collector_app/views/widgets/tiles/timestamp_tile.dart';

class RecordFieldTile extends StatelessWidget {
  final ProjectField field;
  final dynamic value;

  const RecordFieldTile({Key? key, required this.field, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    if (field.type == ProjectFieldType.location) {
      return RecordGeoPointFieldTile(field: field, value: value);
    }
    if (field.type == ProjectFieldType.boolean) {
      return RecordBooleanFieldTile(field: field, value: value == "true");
    }
    if (field.type == ProjectFieldType.date ||
        field.type == ProjectFieldType.dateTime ||
        field.type == ProjectFieldType.time) {
      return RecordTimestampFieldTile(field: field, value: value);
    }
    if (field.type == ProjectFieldType.video ||
        field.type == ProjectFieldType.audio ||
        field.type == ProjectFieldType.image) {
      return RecordFileFieldTile(field: field, value: value);
    }
    if (field.type == ProjectFieldType.locationSeries) {
      return RecordTableFieldTile(
          field: field,
          columnNames: const ["Time", "Longitude", "Latitude"],
          value: value);
    }
    if (field.type == ProjectFieldType.checkBoxes) {
      return RecordMultipleValueFieldTile(field: field, value: value);
    }
    return ListTile(
      title: Text(value.toString()),
      subtitle: Text(field.name),
    );
  }
}
