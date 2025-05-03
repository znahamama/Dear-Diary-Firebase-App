import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/diary_entry_model.dart';

class DiaryEntryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addDiaryEntry(DiaryEntry entry) async {
    await _firestore.collection('diary_entries').doc(entry.id).set(entry.toMap());
  }

  Stream<List<DiaryEntry>> getUserEntries(String userId) {
    return _firestore
        .collection('diary_entries')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => DiaryEntry.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> updateDiaryEntry(DiaryEntry entry) async {
    await _firestore.collection('diary_entries').doc(entry.id).update(entry.toMap());
  }

  Future<void> deleteDiaryEntry(String entryId) async {
    await _firestore.collection('diary_entries').doc(entryId).delete();
  }
}
