import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/job_application_model.dart';
import '../Models/job_vacancy_model.dart';

class JobApplicationController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ----------------------
  // Foreman Methods
  // ----------------------

  /// Foreman applies to a job vacancy
  Future<void> applyJob(JobVacancyModel job) async {
    final uid = _auth.currentUser!.uid;

    // Check if already applied
    final exists =
        await _firestore
            .collection('job_applications')
            .where('vacancyId', isEqualTo: job.id)
            .where('foremanId', isEqualTo: uid)
            .limit(1)
            .get();

    if (exists.docs.isNotEmpty) {
      throw 'Already applied';
    }

    // Add application
    await _firestore.collection('job_applications').add({
      'vacancyId': job.id,
      'foremanId': uid,
      'ownerId': job.ownerId,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Stream of applications submitted by the logged-in Foreman
  Stream<List<JobApplicationModel>> getForemanApplications() {
    final uid = _auth.currentUser!.uid;

    return _firestore
        .collection('job_applications')
        .where('foremanId', isEqualTo: uid)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => JobApplicationModel.fromMap(doc.id, doc.data()))
                  .toList(),
        );
  }

  // ----------------------
  // Owner Methods
  // ----------------------

  /// Stream of applications received by the logged-in Owner
  Stream<List<JobApplicationModel>> getOwnerApplications() {
    final uid = _auth.currentUser!.uid;

    return _firestore
        .collection('job_applications')
        .where('ownerId', isEqualTo: uid)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => JobApplicationModel.fromMap(doc.id, doc.data()))
                  .toList(),
        );
  }

  /// Update the status of an application (pending, accepted, rejected)
  Future<void> updateStatus(String applicationId, String status) async {
    await _firestore.collection('job_applications').doc(applicationId).update({
      'status': status,
    });
  }

  /// Optional: get a single application by ID
  Future<JobApplicationModel?> getApplicationById(String applicationId) async {
    final doc =
        await _firestore
            .collection('job_applications')
            .doc(applicationId)
            .get();
    if (!doc.exists) return null;
    return JobApplicationModel.fromMap(doc.id, doc.data()!);
  }
}
