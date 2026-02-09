import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_headspace/features/journey/data/model/journal_model.dart';

abstract interface class CloudJournalDatasource {
  Future<JournalId> saveEntry(JournalModel journal);

  Future<JournalModel?> getEntry(JournalId id);

  Future<void> deleteEntry(JournalId id);

  Future<List<JournalModel>> getAllEntries();

  Future<void> toggleFavourite(bool value, String id);
}

class CloudJournalDatasourceImpl implements CloudJournalDatasource {
  final FirebaseFirestore _firestore;

  CloudJournalDatasourceImpl(this._firestore);

  @override
  Future<void> deleteEntry(JournalId id) async {
    await _firestore.collection('journals').doc(id).delete();
  }

  @override
  Future<JournalModel?> getEntry(JournalId id) async {
    final doc = await _firestore.collection('journals').doc(id).get();

    if (doc.exists) {
      return JournalModel.fromSnapshot(doc);
    }

    return null;
  }

  @override
  Future<JournalId> saveEntry(JournalModel journal) async {
    if (journal.id != null) {
      await _firestore
          .collection('journals')
          .doc(journal.id)
          .update(journal.toDocument());

      return journal.id!;
    } else {
      final docRef = await _firestore
          .collection('journals')
          .add(journal.toDocument());

      return docRef.id;
    }
  }

  @override
  Future<List<JournalModel>> getAllEntries() async {
    final snapshot = await _firestore.collection('journals').get();

    return snapshot.docs.map((doc) => JournalModel.fromSnapshot(doc)).toList();
  }
  
  @override
  Future<void> toggleFavourite(bool value, String id) async {
    await _firestore.collection('journals').doc(id).update({
      'isFavourite': value,
    });
  }
}
