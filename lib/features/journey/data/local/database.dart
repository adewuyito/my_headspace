import 'dart:io';
// Tumi
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

@DataClassName('JournalEntry')
class Journals extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  IntColumn get color => integer().withDefault(const Constant(0xFFFAFAFA))();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isFavourite => boolean().withDefault(const Constant(false))();
  BoolColumn get isBackedUp => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SyncJob')
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get journalId => text()();
  TextColumn get operation => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Journals, SyncQueue])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) {
          return m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 3) {
            await m.createTable(syncQueue);
          }
        },
      );

  Future<List<JournalEntry>> search(String query) {
    if (query.trim().isEmpty) {
      return select(journals).get();
    }

    final pattern = '%$query%';
    return (select(journals)
          ..where(
            (j) => j.title.like(pattern) | j.content.like(pattern),
          ))
        .get();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
