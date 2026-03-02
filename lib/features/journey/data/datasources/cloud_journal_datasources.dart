import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_headspace/core/constants/exceptions.dart';
import 'package:my_headspace/core/constants/firstore_data_location.dart';
import 'package:my_headspace/features/journey/data/model/journal_model.dart';

abstract interface class CloudJournalDatasource {
  Future<JournalId> saveEntry(JournalModel journal);
  Future<JournalModel?> getEntry(JournalId id);
  Future<void> deleteEntry(JournalId id);
  Future<List<JournalModel>> getAllEntries();
  Future<void> toggleFavourite(bool value, JournalId id);
  Future<bool> syncAllEntries(List<JournalModel> journals);
}

class CloudJournalDatasourceImpl implements CloudJournalDatasource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CloudJournalDatasourceImpl(this._firestore, this._auth);

  /// Get the firestore journal data location for individual users
  CollectionReference get _journalsRef {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw JournalException('User not authenticated');
    return _firestore
        .collection(FirestoreCollectionName.firestoreUser)
        .doc(userId)
        .collection(FirestoreCollectionName.firestoreJournals);
  }

  @override
  Future<void> deleteEntry(JournalId id) async {
    try {
      await _journalsRef.doc(id).delete();
    } on FirebaseException catch (e) {
      throw JournalException('Failed to delete entry: ${e.message}');
    }
  }

  @override
  Future<JournalModel?> getEntry(JournalId id) async {
    try {
      final doc = await _journalsRef.doc(id).get();
      if (doc.exists) return JournalModel.fromSnapshot(doc);
      return null;
    } on FirebaseException catch (e) {
      throw JournalException('Failed to get entry: ${e.message}');
    }
  }

  @override
  Future<JournalId> saveEntry(JournalModel journal) async {
    try {
      final document = {
        ...journal.toDocument(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (journal.id != null) {
        await _journalsRef
            .doc(journal.id)
            .set(document, SetOptions(merge: true));
        return journal.id!;
      } else {
        final docRef = await _journalsRef.add(document);
        return docRef.id;
      }
    } on FirebaseException catch (e) {
      throw JournalException('Failed to save entry: ${e.message}');
    }
  }

  @override
  Future<List<JournalModel>> getAllEntries() async {
    try {
      final snapshot = await _journalsRef
          .orderBy('updatedAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => JournalModel.fromSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw JournalException('Failed to fetch entries: ${e.message}');
    }
  }

  @override
  Future<void> toggleFavourite(bool value, JournalId id) async {
    try {
      await _journalsRef.doc(id).update({
        'isFavourite': value,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw JournalException('Failed to toggle favourite: ${e.message}');
    }
  }

  @override
  Future<bool> syncAllEntries(List<JournalModel> journals) async {
    try {
      final batch = _firestore.batch();
      for (final note in journals) {
        final ref = _journalsRef.doc(note.id);
        batch.set(ref, {
          ...note.toDocument(),
          'isBackedUp': true,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
      await batch.commit();
      return true;
    } catch (_) {
      return false;
    }
  }
}
