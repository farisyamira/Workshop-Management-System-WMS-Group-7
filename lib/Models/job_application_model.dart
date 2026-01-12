import 'package:cloud_firestore/cloud_firestore.dart';

class JobApplicationModel {
  final String id;
  final String vacancyId;
  final String foremanId;
  final String ownerId;
  final String status;
  final DateTime? createdAt;

  JobApplicationModel({
    required this.id,
    required this.vacancyId,
    required this.foremanId,
    required this.ownerId,
    required this.status,
    this.createdAt,
  });

  factory JobApplicationModel.fromMap(String id, Map<String, dynamic> map) {
    DateTime? created;
    if (map['createdAt'] != null) {
      if (map['createdAt'] is Timestamp) {
        created = (map['createdAt'] as Timestamp).toDate();
      } else if (map['createdAt'] is DateTime) {
        created = map['createdAt'] as DateTime;
      }
    }

    return JobApplicationModel(
      id: id,
      vacancyId: map['vacancyId'] ?? '',
      foremanId: map['foremanId'] ?? '',
      ownerId: map['ownerId'] ?? '',
      status: map['status'] ?? 'pending',
      createdAt: created,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vacancyId': vacancyId,
      'foremanId': foremanId,
      'ownerId': ownerId,
      'status': status,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
