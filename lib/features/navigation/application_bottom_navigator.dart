import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/gen/assets.gen.dart';
import 'package:my_headspace/routes/app_route.gr.dart';

@routePage
class ApplicationNavigatorView extends StatelessWidget {
  const ApplicationNavigatorView({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.tabBar(
      routes: [HomeRoute(), HomeRoute(), HomeRoute(), HomeRoute()],
      builder: (context, child, controller) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: child,
          bottomNavigationBar: NavigationBar(
            backgroundColor: Color(0xB7E5E5E5),
            labelTextStyle: WidgetStateProperty.all<TextStyle>(
              hpStyles.m13.copyWith(color: Color(0xFF002116)),
            ),
            indicatorColor: Color(0x62009951),
            selectedIndex: tabsRouter.activeIndex,
            onDestinationSelected: tabsRouter.setActiveIndex,
            destinations: [
              NavigationDestination(
                label: 'Home',
                icon: Assets.icons.homeIcon.svg(),
              ),
              NavigationDestination(
                label: 'Discovery',
                icon: Assets.icons.discoverIcon.svg(),
              ),
              NavigationDestination(
                label: 'My Journey',
                icon: Assets.icons.journeyIcon.svg(),
              ),
              NavigationDestination(
                label: 'More',
                icon: Assets.icons.profileIcon.svg(),
              ),
            ],
          ),
        );
      },
    );
  }
}


/* 

 BottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: tabsRouter.setActiveIndex,
            items: [
              BottomNavigationBarItem(
                label: 'Books',
                icon: Icon(Icons.abc, color: ColorName.appGreen),
              ),
              BottomNavigationBarItem(
                label: 'Profile',
                icon: Icon(Icons.dangerous_outlined, color: ColorName.appGreen),
              ),
              BottomNavigationBarItem(
                label: 'Settings',
                icon: Icon(Icons.face, color: ColorName.appGreen),
              ),
              BottomNavigationBarItem(
                label: 'Settings',
                icon: Icon(Icons.e_mobiledata, color: ColorName.appGreen),
              ),
            ],
          ),
        

 */