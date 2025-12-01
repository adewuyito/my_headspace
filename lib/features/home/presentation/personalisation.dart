import 'package:auto_route/auto_route.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/features/home/application/providers/personalisation_provider.dart';
import 'package:my_headspace/features/home/presentation/widgets/time_selection_widget.dart';
import 'package:my_headspace/features/home/presentation/widgets/day_selection_widget.dart';
import 'package:my_headspace/gen/assets.gen.dart';
import 'package:my_headspace/gen/colors.gen.dart';
import 'package:my_headspace/service/service_locator.dart';
import 'package:provider/provider.dart';

@routePage
class PersonalisationView extends StatelessWidget {
  const PersonalisationView({super.key});

  @override
  Widget build(BuildContext context) {
    final personalisationProvider = serviceLocator
        .getIt<PersonalisationProvider>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: AutoLeadingButton(),
        title: Text("Personalization", style: hpStyles.sb22),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          27,
          21,
          27,
          kBottomNavigationBarHeight,
        ),
        child: Column(
          children: [
            Text(
              "Receive daily motivation reminders to strengthen you faith.",
              style: hpStyles.m14.copyWith(color: Color(0xFF979797)),
            ),

            const SizedBox(height: 45),

            Container(
              height: 376.h,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color.from(
                  alpha: .27,
                  red: 0.851,
                  green: 0.851,
                  blue: 0.851,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ~ Frequency
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("How many times", style: hpStyles.m14),
                      Row(
                        spacing: 18,
                        children: [
                          // ~ Plus button
                          GestureDetector(
                            onTap: () {
                              personalisationProvider.updateDayFrequencyUp();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                color: Color(0xFFD9D9D9),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Assets.icons.plusIcon.svg(),
                            ),
                          ),
                          Selector<PersonalisationProvider, int>(
                            selector: (context, provider) =>
                                provider.dayFrequency,
                            builder: (_, provider, __) {
                              return Text("${provider}x", style: hpStyles.m14);
                            },
                          ),

                          // ~ Minus button
                          GestureDetector(
                            onTap: () {
                              personalisationProvider.updateDayFrequencyDown();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                color: Color(0xFFD9D9D9),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Assets.icons.minusIcon.svg(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  //  ~ Start Date
                  TimeSelectionWiget(
                    label: 'Start at',
                    onDateSelect: () async {
                      final newDateTime = await showAdaptiveDateTimePicker(
                        context: context,
                        mode: DateTimeFieldPickerMode.time,
                      );

                      if (newDateTime != null) {
                        personalisationProvider.updateStartTime(newDateTime);
                      }
                    },
                    child: Selector<PersonalisationProvider, String>(
                      selector: (context, provider) => provider.startTime,
                      builder: (context, provider, child) =>
                          Text(provider, style: hpStyles.m11),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ~ End Date
                  TimeSelectionWiget(
                    label: 'End at',
                    onDateSelect: () async {
                      final newDateTime = await showAdaptiveDateTimePicker(
                        context: context,
                        mode: DateTimeFieldPickerMode.time,
                      );

                      if (newDateTime != null) {
                        personalisationProvider.updateEndTime(newDateTime);
                      }
                    },
                    child: Selector<PersonalisationProvider, String>(
                      selector: (context, provider) => provider.endTime,
                      builder: (context, provider, child) =>
                          Text(provider, style: hpStyles.m11),
                    ),
                  ),

                  const SizedBox(height: 31),

                  // ~ Repeat days˝
                  DaySelectionWidget(),

                  const SizedBox(height: 24),

                  // ~ Tone
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Repeat", style: hpStyles.m14),
                      IconButton(
                        onPressed: () {},
                        icon: Row(
                          spacing: 7,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Bird chirp",
                              style: hpStyles.m11.copyWith(
                                color: ColorName.textGray78,
                              ),
                            ),
                            Assets.icons.caratRight.svg(
                              width: 12,
                              height: 12,
                              color: ColorName.textGray78,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Spacer(),

            SizedBox(
              width: 253,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorName.appOrange,
                  elevation: 1,
                ),
                onPressed: () {},
                child: Text("Update"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
