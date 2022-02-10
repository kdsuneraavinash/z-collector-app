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
      case ProjectFieldType.video:
      case ProjectFieldType.audio:
        return _extractFile(value);
      case ProjectFieldType.checkBoxes:
        return _extractMultipleNumeric(value);
      case ProjectFieldType.radio:
      case ProjectFieldType.dropdown:
      case ProjectFieldType.numeric:
        return _extractNumeric(value);
      default:
        return _extractString(value);
    }
  }

  Timestamp? _extractTimestamp(dynamic value) {
    if (value is DateTime) return Timestamp.fromDate(value);
    return null;
  }

  String? _extractFile(dynamic value) {
    if (value is List<dynamic>) {
      final firstNotNull =
          value.firstWhere((e) => e != null, orElse: () => null);
      if (firstNotNull is XFile) {
        final files = List<XFile?>.from(value);
        return files[0]?.path;
      }
      if (firstNotNull is PlatformFile) {
        final files = List<PlatformFile?>.from(value);
        return files[0]?.path;
      }
    }
    return null;
  }

  String _extractMultipleNumeric(dynamic value) {
    // [cloud_firestore/unknown] Invalid data. Nested arrays are not supported
    // So storing as comma separated values.
    if (value is List) return List<num>.from(value).join(",");
    return "";
  }

  num? _extractNumeric(dynamic value) {
    if (value is num) return value;
    if (value is String) return num.tryParse(value);
    return null;
  }

  String? _extractString(dynamic value) {
    return value?.toString();
  }
}
