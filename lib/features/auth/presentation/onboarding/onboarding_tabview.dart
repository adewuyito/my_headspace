import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:my_headspace/gen/assets.gen.dart';
import 'package:my_headspace/gen/colors.gen.dart';
import 'package:my_headspace/routes/app_navigator.dart';

import 'package:my_headspace/routes/app_route.gr.dart';

@routePage
class OnboardingTabviewPage extends StatelessWidget {
  const OnboardingTabviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.pageView(
      routes: const [
        OnboardingFirstTabRoute(),
        OnboardingSecondTabRoute(),
        OnboardingThirdTabRoute(),
      ],

      builder: (context, child, _) {
        return Scaffold(
          body: Stack(
            children: [
              child,
              Positioned(
                bottom: 50,
                left: 20,
                right: 20,
                child: Padding(
                  padding: const EdgeInsets.only(right: 32.0, left: 31),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        spacing: 9,
                        children: List.generate(3, (index) {
                          final tabsRouter = AutoTabsRouter.of(context);
                          final isActive = tabsRouter.activeIndex == index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                            width: isActive ? 30 : 15,
                            height: 15,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? ColorName.appOrange
                                  : const Color(0xFF86AC8F),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          );
                        }),
                      ),

                      FloatingActionButton(
                        elevation: 0,
                        backgroundColor: Color(0xFF104423),
                        shape: CircleBorder(),
                        onPressed: () {
                          final tabsRouter = AutoTabsRouter.of(context);
                          if (tabsRouter.activeIndex <
                              tabsRouter.pageCount - 1) {
                            tabsRouter.setActiveIndex(
                              tabsRouter.activeIndex + 1,
                            );
                          } else {
                            AppNavigator.of(context).replace(GetStartedRoute());
                          }
                        },
                        child: Assets.icons.caratRight.svg(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
