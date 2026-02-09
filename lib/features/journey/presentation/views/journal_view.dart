/* import 'package:flutter/material.dart';
import 'package:my_headspace/features/journey/application/providers/journal_provider.dart';
import 'package:my_headspace/service/service_locator.dart';
import 'package:provider/provider.dart';

class JournalView extends StatefulWidget {
  const JournalView({super.key});

  @override
  State<JournalView> createState() => _JournalViewState();
}

class _JournalViewState extends State<JournalView> {
  late final JournalProvider _journalProvider;

  @override
  void initState() {
    super.initState();
    _journalProvider = serviceLocator.getIt<JournalProvider>();
    _journalProvider.getAllJournals();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _journalProvider,
      child: Consumer<JournalProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Journal'),
            ),
            body: provider.state.journals.isEmpty
                ? const Center(
                    child: Text('You have no notes yet.'),
                  )
                : ListView.builder(
                    itemCount: (provider.state.journals.length * 2) - 1,
                    itemBuilder: (context, index) {
                      if (index.isOdd) {
                        return const Divider();
                      }

                      final itemIndex = index ~/ 2;
                      final journal = provider.state.journals[itemIndex];
                      return ListTile(
                        title: Text(journal.title),
                        subtitle: Text(journal.content),
                      );
                    },
                  ),

            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // TODO: Navigate to add journal screen
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
 */