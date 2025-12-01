import 'package:flutter/material.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/features/home/application/providers/personalisation_provider.dart';
import 'package:my_headspace/gen/colors.gen.dart';
import 'package:my_headspace/service/service_locator.dart';
import 'package:provider/provider.dart';

class DaySelectionWidget extends StatelessWidget {
  const DaySelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final personalisationProvider = serviceLocator
        .getIt<PersonalisationProvider>();
    return Column(
      spacing: 17,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Repeat", style: hpStyles.m14),
        Selector<PersonalisationProvider, Set<WeekDay>>(
          selector: (context, provider) => provider.weekDaysFrequency,
          shouldRebuild: (previous, next) => true,
          builder: (context, selectedDays, child) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: WeekDay.values.map((e) {
              final day = e.name.toUpperCase().characters.first;
              final isSelected = selectedDays.contains(e);
              return GestureDetector(
                onTap: () {
                  personalisationProvider.toggleRepeatDay(e);
                },
                child: Container(
                  alignment: AlignmentGeometry.center,
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1,
                      color: isSelected
                          ? ColorName.appOrange
                          : Colors.transparent,
                    ),
                  ),
                  child: Text(day),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
