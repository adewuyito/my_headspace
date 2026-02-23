import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_headspace/features/journey/application/providers/journal_provider.dart';
import 'package:my_headspace/features/journey/data/local/database.dart';
import 'package:my_headspace/features/journey/domain/entities/journal_entity.dart';
import 'package:my_headspace/features/journey/presentation/journey_view.dart';
import 'package:my_headspace/service/service_locator.dart';

import '../../unit-features/journey/support/journal_provider_test_support.dart';

void main() {
  late AppDatabase database;
  late JournalProvider provider;

  Future<void> pumpJourneyView(WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (_, __) => const MaterialApp(home: JourneyView()),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUpAll(() {
    registerJournalProviderFallbacks();
  });

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    provider = buildProviderWithInMemoryDb(database);

    if (serviceLocator.getIt.isRegistered<JournalProvider>()) {
      serviceLocator.getIt.unregister<JournalProvider>();
    }
    serviceLocator.getIt.registerSingleton<JournalProvider>(provider);
  });

  tearDown(() async {
    if (serviceLocator.getIt.isRegistered<JournalProvider>()) {
      serviceLocator.getIt.unregister<JournalProvider>();
    }
    await database.close();
  });

  testWidgets('shows journey view empty state on initial load', (tester) async {
    await pumpJourneyView(tester);

    expect(find.text('Journal Entries'), findsOneWidget);
    expect(find.text('Search by title...'), findsOneWidget);
    expect(find.text('Empty journal'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('renders journal list when journals exist', (tester) async {
    final quillDelta = jsonEncode([
      {'insert': 'My preview content'},
    ]);

    await provider.saveJournal(
      Journal(
        id: 'journal-ui-1',
        title: 'A saved journey',
        content: quillDelta,
        createdAt: DateTime(2026, 2, 23),
      ),
    );

    await pumpJourneyView(tester);

    expect(find.text('Empty journal'), findsNothing);
    expect(find.text('A saved journey'), findsOneWidget);
    expect(find.text('My preview content'), findsOneWidget);
    expect(find.text('23rd Feb 2026'), findsOneWidget);
  });
}
