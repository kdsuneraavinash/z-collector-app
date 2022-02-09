import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class FirestoreReference
    implements JsonConverter<DocumentReference, DocumentReference> {
  const FirestoreReference();

  @override
  DocumentReference<Object?> fromJson(DocumentReference<Object?> docRef) =>
      docRef;

  @override
  DocumentReference<Object?> toJson(DocumentReference<Object?> docRef) =>
      docRef;
}
