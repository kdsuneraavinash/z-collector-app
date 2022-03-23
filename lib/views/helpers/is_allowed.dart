import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:z_collector_app/models/project.dart';

bool isAllowedToAddRecord(
    DocumentReference<Map<String, dynamic>> userRef, Project project) {
  // If private, must be in allowed users, but not in blacklisted
  if (project.isPrivate) {
    if (project.blacklistedUsers.contains(userRef)) {
      return false;
    }
    if (!project.allowedUsers.contains(userRef)) {
      return false;
    }
    return true;
  }

  // If public, must not be in blacklisted
  if (project.blacklistedUsers.contains(userRef)) {
    return false;
  }
  return true;
}
