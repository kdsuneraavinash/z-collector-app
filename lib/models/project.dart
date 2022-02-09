import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:z_collector_app/models/utils/reference.dart';

part 'project.g.dart';

@JsonSerializable()
@FirestoreReference()
class Project {
  final String name;
  final String description;
  final DocumentReference owner;
  final String? imageUrl;
  final bool isPrivate;
  final bool isPublished;
  final String? entryCode;
  final List<DocumentReference> allowedUsers;
  final List<DocumentReference> blacklistedUsers;
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

  List<dynamic> extractValues(Map<String, dynamic> valueFields) {
    final values = [];
    for (int i = 0; i < fields.length; i++) {
      final key = i.toString();
      if (valueFields.containsKey(key)) {
        values.add(extractValue(fields[i].type, valueFields[key]));
      } else {
        values.add(null);
      }
    }
    return values;
  }

  dynamic extractValue(ProjectFieldType type, dynamic value) {
    switch (type) {
      case ProjectFieldType.dateTime:
      case ProjectFieldType.date:
      case ProjectFieldType.time:
        return Timestamp.fromDate(value);
      case ProjectFieldType.numeric:
        return int.tryParse(value) ?? 0;
      default:
        return value;
    }
  }
}

@JsonSerializable()
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
