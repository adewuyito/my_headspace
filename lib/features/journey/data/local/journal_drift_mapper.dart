import 'package:my_headspace/features/journey/data/local/database.dart';
import 'package:my_headspace/features/journey/data/model/journal_model.dart';

class JournalDriftMapper {
  static JournalEntry toDrift(JournalModel model) {
    return JournalEntry(
      id: model.id!,
      title: model.title,
      content: model.content,
      createdAt: model.createdAt,
      isFavourite: model.isFavourite,
      color: model.color,
      isBackedUp: model.isBackedUp,
    );
  }

  static JournalModel fromDrift(JournalEntry entry) {
    return JournalModel(
      id: entry.id,
      title: entry.title,
      content: entry.content,
      createdAt: entry.createdAt,
      isFavourite: entry.isFavourite,
      color: entry.color,
      isBackedUp: entry.isBackedUp,
    );
  }
}
