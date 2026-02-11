import 'package:my_headspace/features/journey/data/model/journal_model.dart';
import 'package:my_headspace/features/journey/domain/entities/journal_entity.dart';

class JournalMapper {
  static Journal toEntity(JournalModel model) {
    return Journal(
      id: model.id,
      title: model.title,
      content: model.content,
      createdAt: model.createdAt,
      isFavourite: model.isFavourite,
      color: model.color,
    );
  }

  static JournalModel fromEntity(Journal entity) {
    return JournalModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      createdAt: entity.createdAt,
      isFavourite: entity.isFavourite,
      color: entity.color,
    );
  }
}
