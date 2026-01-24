import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_headspace/core/constants/spacing.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/features/journey/presentation/widget/journey_card.dart';
import 'package:my_headspace/features/journey/presentation/widget/journey_date_divider.dart';

@routePage
class JourneyView extends HookWidget {
  const JourneyView({super.key});

  @override
  Widget build(BuildContext context) {
    final searchTextController = useTextEditingController();
    return Scaffold(
      appBar: AppBar(title: Text("Journal Entries")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: AppPadding.scaffoldSpacing,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: searchTextController, decoration: InputDecoration(
                prefix: Icon(Icons.search),
                hint: Text("Search by title...", style: hpStyles.m16,)
              ),),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return JourneyCard(heading: "", body: textPlaceholder);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return JourneyDateDivider(date: "10th Jan 2024");
                  },
                  itemCount: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String textPlaceholder =
    "Lorem ifpskd ei skdosl skde ksheks die ksheks kek skdjsjdns key skde skeks djdk ske ksue kseksjeui kdkhe.";
