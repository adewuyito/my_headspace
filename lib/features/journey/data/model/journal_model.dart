class JournalModel {
  final JournalId id;
  final String title;
  final String body;
  final DateTime createdAt;

  JournalModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  JournalModel copyWith({String? title, String? body, DateTime? createdAt}) =>
      JournalModel(
        id: id,
        title: title ?? this.title,
        body: body ?? this.body,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  bool operator ==(covariant JournalModel other) {
    return identical(this, other) || (id == other.id);
  }

  @override
  int get hashCode => Object.hash(id, title, body, createdAt);
}

typedef JournalId = String;
