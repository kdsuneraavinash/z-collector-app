import 'package:cloud_firestore/cloud_firestore.dart';

Query<Map<String, dynamic>> getMyProjects(String currentUserId) {
  final userRef =
      FirebaseFirestore.instance.collection('users').doc(currentUserId);
  return FirebaseFirestore.instance
      .collection('projects')
      .where('owner', isEqualTo: userRef);
}

Query<Map<String, dynamic>> getPrivateProjects(String currentUserId) {
  // TODO: implement correct logic
  final userRef =
      FirebaseFirestore.instance.collection('users').doc(currentUserId);
  return FirebaseFirestore.instance
      .collection('projects')
      .where('owner', isNotEqualTo: userRef)
      .where('isPrivate', isEqualTo: true);
}

Query<Map<String, dynamic>> getPublicProjects() {
  return FirebaseFirestore.instance
      .collection('projects')
      .where('isPrivate', isEqualTo: false);
}
