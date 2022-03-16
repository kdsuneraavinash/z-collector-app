import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:z_collector_app/models/utils/geopoint.dart';
import 'package:z_collector_app/models/utils/reference.dart';
import 'package:z_collector_app/models/utils/timestamp.dart';

part 'record.g.dart';

@JsonSerializable()
@FirestoreReference()
@FirestoreTimestamp()
@FirestoreGeoPoint()
class Record {
  final DocumentReference<Map<String, dynamic>> user;
  final DocumentReference<Map<String, dynamic>> project;
  final Timestamp timestamp;
  final RecordStatus status;
  final List<dynamic> fields;

  factory Record.fromJson(Map<String, dynamic> json) => _$RecordFromJson(json);

  Record({
    required this.user,
    required this.project,
    required this.timestamp,
    required this.status,
    required this.fields,
  });

  Map<String, dynamic> toJson() => _$RecordToJson(this);

  List<String> fieldValues() => [
        for (final field in fields)
          if (field is Timestamp)
            field.toDate().toIso8601String()
          else if (field is GeoPoint)
            "${field.longitude} ${field.latitude}"
          else
            field.toString()
      ];
}

enum RecordStatus {
  @JsonValue('DONE')
  done,
  @JsonValue('UPLOADING')
  uploading,
  @JsonValue('FAILED')
  failed,
}
