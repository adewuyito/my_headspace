import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_headspace/core/constants/spacing.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/core/utils/date_time_formatting.dart';
import 'package:my_headspace/core/utils/json_utils.dart';
import 'package:my_headspace/features/journey/application/providers/journal_provider.dart';
import 'package:my_headspace/features/journey/presentation/widget/journey_card.dart';
import 'package:my_headspace/features/journey/presentation/widget/journey_date_divider.dart';
import 'package:my_headspace/gen/colors.gen.dart';
import 'package:my_headspace/routes/app_navigator.dart';
import 'package:my_headspace/routes/app_route.gr.dart';
import 'package:my_headspace/service/service_locator.dart';
import 'package:provider/provider.dart';

@routePage
class JourneyView extends HookWidget {
  const JourneyView({super.key});

  @override
  Widget build(BuildContext context) {
    final searchTextController = useTextEditingController();
    final _journalProvider = useMemoized(
      () => serviceLocator.getIt<JournalProvider>(),
    );
    useEffect(() {
      _journalProvider.getAllJournals();

      return null;
    }, []);

    return ChangeNotifierProvider<JournalProvider>.value(
      value: _journalProvider,
      child: Consumer<JournalProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Journal Entries",
                style: hpStyles.m25.copyWith(color: ColorName.surface),
              ),
              centerTitle: false,
              elevation: 0,
              scrolledUnderElevation: 0,
              surfaceTintColor: Colors.transparent,
              backgroundColor: ColorName.background,
              shadowColor: Colors.transparent,
            ),
            floatingActionButton: FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              onPressed: () {
                AppNavigator.of(context).push(JournalExpandedRoute());
              },
              child: Icon(Icons.add),
            ),
            body: Padding(
              padding: AppPadding.bodySpacing,
              child: Column(
                children: [
                  // ~ Search field
                  TextField(
                    controller: searchTextController,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 19.0, right: 8.0),
                        child: Icon(Icons.search, color: Color(0xFF98A2B3)),
                      ),
                      hint: Text(
                        "Search by title...",
                        style: hpStyles.m16.copyWith(color: Color(0xFF98A2B3)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Color(0xFF98A2B3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Color(0xFF98A2B3)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (provider.state.isLoading)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (provider.state.errorMessage != null)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(provider.state.errorMessage!),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: provider.getAllJournals,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (provider.state.journals.isEmpty)
                    const Expanded(child: Center(child: Text("Empty journal")))
                  else
                    Expanded(
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: provider.state.journals.length,
                            itemBuilder: (context, index) {
                              final journal = provider.state.journals[index];
                              Color cardColor = Color(journal.color);
                              return Column(
                                children: [
                                  // ~ Journal Card
                                  JourneyCard(
                                    color: cardColor,
                                    id: journal.id!,
                                    heading: journal.title,
                                    body: extractTextFromJson(journal.content),
                                    onTap: () {
                                      AppNavigator.of(context).push(
                                        JournalExpandedRoute(journal: journal),
                                      );
                                    },
                                  ),
                                  JourneyDateDivider(
                                    date: journal.createdAt.toOrdinalString(),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
