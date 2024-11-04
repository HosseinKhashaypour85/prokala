import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prokalaproject/const/theme/colors.dart';
import 'package:prokalaproject/const/theme/theme.dart';
import 'package:prokalaproject/features/cart_features/screen/check_cart.dart';
import 'package:prokalaproject/features/home_features/screens/home_screen.dart';
import 'package:prokalaproject/features/profile_features/screen/check_profile.dart';
import 'package:prokalaproject/features/public_features/changetheme/logic/change_theme_cubit.dart';
import 'package:prokalaproject/features/public_features/logic/bottom_nav_cubit.dart';
import 'package:prokalaproject/features/public_features/logic/token_checker/token_check_cubit.dart';

import '../../category_features/screens/category_screen.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  static const String screenId = '/bottomnavbar';

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  List<Widget> screenList = [
    const HomeScreen(),
    const CategoryScreen(),
    const CheckCartScreen(),
    const CheckProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TokenCheckCubit>(context).tokenChecker();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<BottomNavCubit, int>(
      builder: (context, state) {
        final bottomNavCubit = BlocProvider.of<BottomNavCubit>(context);
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: primaryColor,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            unselectedItemColor:
                BlocProvider.of<ChangethemeCubit>(context).customTheme ==
                        CustomTheme.darkTheme
                    ? Colors.black
                    : theme.iconTheme.color,
            selectedLabelStyle: const TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'sahelbold',
            ),
            unselectedLabelStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'sahelbold',
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'صفحه اصلی',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.category,
                ),
                label: 'دسته بندی ها',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.shopping_cart,
                ),
                label: 'سبد خرید',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: 'پروفایل',
              ),
            ],
            currentIndex: bottomNavCubit.screenIndex,
            onTap: (value) {
              BlocProvider.of<BottomNavCubit>(context).onTap(value);
            },
          ),
          body: screenList
              .elementAt(BlocProvider.of<BottomNavCubit>(context).screenIndex),
        );
      },
    );
  }
}
