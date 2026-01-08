import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/features/auth/application/providers/create_account_provider.dart';
import 'package:my_headspace/gen/colors.gen.dart';
import 'package:my_headspace/routes/app_navigator.dart';
import 'package:my_headspace/routes/app_route.gr.dart';
import 'package:provider/provider.dart';

@RoutePage(name: 'SignupTabviewRoute')
class SignupTabViewPage extends StatefulWidget {
  const SignupTabViewPage({super.key});

  @override
  State<SignupTabViewPage> createState() => _SignupTabViewPageState();
}

class _SignupTabViewPageState extends State<SignupTabViewPage> {
  late CreateAccountProvider _createAccountProvider;

  @override
  void initState() {
    super.initState();
    _createAccountProvider = context.read<CreateAccountProvider>();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _createAccountProvider.clearUserData();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateAccountProvider>(
      builder: (context, value, child) {
        return AutoTabsRouter.pageView(
          physics: NeverScrollableScrollPhysics(),
          routes: [CreateAccountRoute1(), CreateAccountRoute2()],
          animatePageTransition: true,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          builder: (context, child, pageController) {
            return Scaffold(
              appBar: AppBar(
                leading: BackButton(
                  onPressed: () {
                    final tabsRouter = AutoTabsRouter.of(context);

                    if (tabsRouter.activeIndex > 0) {
                      tabsRouter.setActiveIndex(tabsRouter.activeIndex - 1);
                    } else {
                      context.router.pop();
                    }
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      AppNavigator.of(context).push(LoginRoute());
                    },
                    child: Text(
                      "Log in",
                      style: hpStyles.b16.copyWith(color: ColorName.appOrange),
                    ),
                  ),
                ],
              ),
              body: child,
            );
          },
        );
      },
    );
  }
}
