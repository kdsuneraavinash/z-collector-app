import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:z_collector_app/models/utils/reference.dart';

part 'project.g.dart';

@JsonSerializable(explicitToJson: true)
@FirestoreReference()
class Project {
  final String name;
  final String description;
  final DocumentReference<Map<String, dynamic>> owner;
  final String? imageUrl;
  final bool isPrivate;
  final bool isPublished;
  final String? entryCode;
  final List<DocumentReference<Map<String, dynamic>>> allowedUsers;
  final List<DocumentReference<Map<String, dynamic>>> blacklistedUsers;
  final List<ProjectField> fields;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Project({
    required this.name,
    required this.description,
    required this.owner,
    required this.imageUrl,
    required this.isPrivate,
    required this.isPublished,
    required this.entryCode,
    required this.allowedUsers,
    required this.blacklistedUsers,
    required this.fields,
  });

  Map<String, dynamic> toJson() => _$ProjectToJson(this);

  List<String> fieldHeaders() => fields.map((e) => e.name).toList();
}

@JsonSerializable(explicitToJson: true)
class ProjectField {
  final String name;
  final ProjectFieldType type;
  final String? helperText;
  final List<ProjectFieldValidator> validators;
  final List<String>? options;

  factory ProjectField.fromJson(Map<String, dynamic> json) =>
      _$ProjectFieldFromJson(json);

  ProjectField({
    required this.name,
    required this.type,
    required this.helperText,
    required this.validators,
    required this.options,
  });

  Map<String, dynamic> toJson() => _$ProjectFieldToJson(this);
}

@JsonSerializable()
class ProjectFieldValidator {
  final ProjectFieldValidatorType type;
  final dynamic value;

  factory ProjectFieldValidator.fromJson(Map<String, dynamic> json) =>
      _$ProjectFieldValidatorFromJson(json);

  ProjectFieldValidator({
    required this.type,
    required this.value,
  });

  Map<String, dynamic> toJson() => _$ProjectFieldValidatorToJson(this);
}

enum ProjectFieldType {
  @JsonValue('STRING')
  string,
  @JsonValue('NUMERIC')
  numeric,
  @JsonValue('LOCATION')
  location,
  @JsonValue('LOCATION_SERIES')
  locationSeries,
  @JsonValue('IMAGE')
  image,
  @JsonValue('VIDEO')
  video,
  @JsonValue('AUDIO')
  audio,
  @JsonValue('TEXT')
  text,
  @JsonValue('BOOLEAN')
  boolean,
  @JsonValue('DATETIME')
  dateTime,
  @JsonValue('DATE')
  date,
  @JsonValue('TIME')
  time,
  @JsonValue('DROPDOWN')
  dropdown,
  @JsonValue('RADIO')
  radio,
  @JsonValue('CHECKBOXES')
  checkBoxes,
}

enum ProjectFieldValidatorType {
  @JsonValue('REQUIRED')
  required,
  @JsonValue('EMAIL')
  email,
  @JsonValue('INTEGER')
  integer,
  @JsonValue('MATCH')
  match,
  @JsonValue('MAX')
  max,
  @JsonValue('MIN')
  min,
  @JsonValue('MAXLENGTH')
  maxLength,
  @JsonValue('MINLENGTH')
  minLength,
  @JsonValue('URL')
  url,
}

class SeriesDataPoint<T> {
  final DateTime timestamp;
  final T dataPoint;

  SeriesDataPoint._(this.timestamp, this.dataPoint);

  String toRepr() {
    final dataPoint = this.dataPoint;
    if (dataPoint is Position) {
      return "${timestamp.toIso8601String()}|${dataPoint.longitude}|${dataPoint.latitude}";
    }
    throw UnimplementedError();
  }

  factory SeriesDataPoint(T dataPoint) {
    return SeriesDataPoint._(DateTime.now(), dataPoint);
  }

  static SeriesDataPoint<Position> positionFromRepr(String repr) {
    final values = repr.split("|");
    final timestamp =
        DateTime.tryParse(values[0]) ?? DateTime.fromMicrosecondsSinceEpoch(0);
    final longitude = double.tryParse(values[1]) ?? 0;
    final latitude = double.tryParse(values[2]) ?? 0;
    return SeriesDataPoint._(timestamp,
        Position.fromMap({"longitude": longitude, "latitude": latitude}));
  }
}
