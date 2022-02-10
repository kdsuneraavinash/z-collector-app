import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_file/cross_file.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:z_collector_app/models/project.dart';

class FormDataManager {
  final String projectId;
  final String userId;
  final Project project;
  final Map<String, Reference> fileUploads;

  FormDataManager({
    required this.projectId,
    required this.userId,
    required this.project,
  }) : fileUploads = {};

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
      case ProjectFieldType.location:
        return _extractLocation(value);
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
    if (value is! List<dynamic>) return null;
    // TODO: Support 0 or more elements as well.
    final file = value[0];
    if (file is XFile) return _extractXFile(file);
    if (file is PlatformFile) {
      final path = file.path;
      if (path == null) return null;
      final xFile = XFile(path, name: file.name, bytes: file.bytes);
      return _extractXFile(xFile);
    }
    return null;
  }

  String _extractMultipleNumeric(dynamic value) {
    // [cloud_firestore/unknown] Invalid data. Nested arrays are not supported
    // So storing as comma separated values.
    if (value is List) return List<num>.from(value).join(",");
    return "";
  }

  GeoPoint? _extractLocation(dynamic value) {
    if (value is Position) return GeoPoint(value.latitude, value.longitude);
    return null;
  }

  num? _extractNumeric(dynamic value) {
    if (value is num) return value;
    if (value is String) return num.tryParse(value);
    return null;
  }

  String? _extractString(dynamic value) {
    return value?.toString();
  }

  String? _extractXFile(XFile file) {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('projects')
        .child(projectId)
        .child(userId)
        .child(file.name);
    fileUploads[file.path] = storageRef;
    return storageRef.fullPath;
  }

  void startUploading() async {
    // TODO: Support uploading after app exits.
    // TODO: Support progress notifications
    for (final fileUpload in fileUploads.entries) {
      fileUpload.value.putFile(File(fileUpload.key));
    }
  }
}
