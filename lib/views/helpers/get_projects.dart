import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<QuerySnapshot<Map<String, dynamic>>> getMyProjects() async {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
  return FirebaseFirestore.instance
      .collection('projects')
      .where('owner', isEqualTo: userRef)
      .get();
}

Future<QuerySnapshot<Map<String, dynamic>>> getPrivateProjects() async {
  // TODO: implement correct logic
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
  return FirebaseFirestore.instance
      .collection('projects')
      .where('owner', isNotEqualTo: userRef)
      .where('isPrivate', isEqualTo: true)
      .get();
}

Future<QuerySnapshot<Map<String, dynamic>>> getPublicProjects() async {
  return FirebaseFirestore.instance
      .collection('projects')
      .where('isPrivate', isEqualTo: false)
      .get();
}
