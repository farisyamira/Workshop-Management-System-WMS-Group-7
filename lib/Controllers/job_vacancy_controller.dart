import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/job_vacancy_model.dart';

class JobVacancyController {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get ownerId => _auth.currentUser!.uid;

  Future<void> createVacancy(JobVacancyModel vacancy) async {
    await _firestore.collection('job_vacancies').add(vacancy.toMap());
  }

  Stream<List<JobVacancyModel>> getAllVacancies() {
    return _firestore
        .collection('job_vacancies')
        .where('status', isEqualTo: 'open')
        .snapshots()
        .map(
          (snap) =>
              snap.docs
                  .map((d) => JobVacancyModel.fromMap(d.id, d.data()))
                  .toList(),
        );
  }

  Future<DocumentSnapshot> getVacancyById(String id) {
    return _firestore.collection('job_vacancies').doc(id).get();
  }

  Future<void> updateVacancyStatus(String vacancyId, String status) async {
    await _firestore.collection('job_vacancies').doc(vacancyId).update({
      'status': status,
    });
  }
}
