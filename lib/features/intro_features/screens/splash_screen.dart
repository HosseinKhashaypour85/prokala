import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prokalaproject/const/responsive.dart';
import 'package:prokalaproject/const/shape/media_query.dart';
import 'package:prokalaproject/const/theme/colors.dart';
import 'package:prokalaproject/features/home_features/screens/home_screen.dart';
import 'package:prokalaproject/features/intro_features/screens/intro_screen.dart';
import 'package:prokalaproject/features/pref/shared_pref.dart';
import 'package:prokalaproject/features/public_features/screens/bottom_nav_bar_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String screenId = '/splash_screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  navigatorFunc() {
    Timer(
      Duration(seconds: 3),
      () async {
        if (await SharedPref().getIntroStatus()) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(BottomNavBarScreen.screenId, (route) => false);
        } else {
          Navigator.of(context).pushReplacementNamed(BottomNavBarScreen.screenId);
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    navigatorFunc();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = Responsive.isDesktop(context);
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: FadeInUp(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: isDesktop
                    ? getWidth(context, 0.5)
                    : isMobile
                        ? getWidth(context, 0.1)
                        : isTablet
                            ? getWidth(context, 0.4)
                            : getWidth(context, 0.4),
                backgroundColor: theme.scaffoldBackgroundColor,
                child: Image.asset(
                  'assets/images/logo2.png',
                  width: isDesktop
                      ? getWidth(context, 0.3)
                      : isMobile
                          ? getWidth(context, 0.175)
                          : isTablet
                              ? getWidth(context, 0.2)
                              : getWidth(context, 0.2),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Prokala',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: isDesktop
                        ? 18.sp
                        : isMobile
                            ? 15.sp
                            : isTablet
                                ? 16.sp
                                : 16.sp,
                    fontFamily: 'sahelbold'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
