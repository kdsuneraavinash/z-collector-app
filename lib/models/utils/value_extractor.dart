import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_file/cross_file.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:z_collector_app/models/project.dart';

class ValueExtractor {
  final Project project;

  ValueExtractor(this.project);

  List<dynamic> extract(Map<String, dynamic> valueFields) {
    final values = [];
    for (int i = 0; i < project.fields.length; i++) {
      final key = i.toString();
      if (valueFields.containsKey(key)) {
        values.add(_extractValue(project.fields[i].type, valueFields[key]));
      } else {
        values.add(null);
      }
    }
    return values;
  }

  dynamic _extractValue(ProjectFieldType type, dynamic value) {
    switch (type) {
      case ProjectFieldType.dateTime:
      case ProjectFieldType.date:
      case ProjectFieldType.time:
        return _extractTimestamp(value);
      case ProjectFieldType.image:
        return _extractImage(value);
      case ProjectFieldType.video:
      case ProjectFieldType.audio:
        return _extractFile(value);
      case ProjectFieldType.numeric:
        return _extractNumeric(value);
      default:
        return _extractString(value);
    }
  }

  Timestamp? _extractTimestamp(dynamic value) {
    final DateTime? dateTime = value;
    return dateTime != null ? Timestamp.fromDate(dateTime) : null;
  }

  String? _extractImage(dynamic value) {
    // TODO: Save file location and start uploading to a path
    // TODO: Return upload location
    final files = List<XFile?>.from(value);
    return files[0]?.path;
  }

  String? _extractFile(dynamic value) {
    // TODO: Save file location and start uploading to a path
    // TODO: Return upload location
    final files = List<PlatformFile?>.from(value);
    return files[0]?.path;
  }

  int? _extractNumeric(dynamic value) =>
      value != null ? int.tryParse(value) : null;

  String? _extractString(dynamic value) => value;
}
