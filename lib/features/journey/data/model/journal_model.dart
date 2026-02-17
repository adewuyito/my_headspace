import 'package:cloud_firestore/cloud_firestore.dart';

typedef JournalId = String;

class JournalModel {
  final JournalId? id;
  final String title;
  final String content;
  final DateTime createdAt;
  final bool isFavourite;
  final int color;
  final bool isBackedUp;

  JournalModel({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.isFavourite = false,
    required this.color,
    this.isBackedUp = false,
  });

  factory JournalModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return JournalModel(
      id: doc.id,
      title: data['title'] as String,
      content: data['content'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isFavourite: data['isFavourite'] as bool? ?? false,
      color: data['color'] as int,
      isBackedUp: data['isBackedUp'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'title': title,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'isFavourite': isFavourite,
      'color': color,
      'isBackedUp': isBackedUp,
    };
  }
}