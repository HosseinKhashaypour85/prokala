import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prokalaproject/const/shape/media_query.dart';
import 'package:prokalaproject/const/theme/colors.dart';
import 'package:prokalaproject/const/theme/theme.dart';
import 'package:prokalaproject/features/authentication_features/logic/auth_bloc.dart';
import 'package:prokalaproject/features/authentication_features/services/auth_repository.dart';
import 'package:prokalaproject/features/favorite_feautures/screen/favorite_screen.dart';
import 'package:prokalaproject/features/home_features/screens/home_screen.dart';
import 'package:prokalaproject/features/intro_features/screens/splash_screen.dart';
import 'package:prokalaproject/features/public_features/changetheme/logic/change_theme_cubit.dart';
import 'package:prokalaproject/features/public_features/widget/snack_bar.dart';

import '../../../const/responsive.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const String screenId = '/profile_screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SecondSearchBarWidget(theme: theme),
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                Column(
                  children: [
                    SizedBox(
                      height: 10.sp,
                    ),
                    CircleAvatar(
                      radius: getWidth(context, 0.1),
                      backgroundColor: Colors.red.shade100,
                      child: Icon(
                        Icons.person,
                        color: primaryColor,
                        size: getWidth(context, 0.07),
                      ),
                    ),
                    Text(
                      'کاربر عزیز',
                      style: TextStyle(
                        fontFamily: 'sahelbold',
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(
                      height: 35.sp,
                    ),
                    ListTile(
                      title: Text(
                        'علاقه مندی ها',
                        style: TextStyle(
                          fontFamily: 'sahelbold',
                          fontSize: 12.sp,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_rounded),
                      onTap: () {
                        Navigator.pushNamed(context, FavoriteScreen.screenId);
                      },
                    ),
                    ListTile(
                      title: Text(
                        'درباره ما',
                        style: TextStyle(
                          fontFamily: 'sahelbold',
                          fontSize: 12.sp,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_rounded),
                      onTap: () {
                        final description =
                            'حسین خشای پور هستم برنامه نویس فلاتر و طراحی اپلیکیشن انجام میدم . در کنار طراحی اپلیکیشن طراحی سایت کد نویسی شده انجام میدم و تجربه کاری دارم و نمونه کار های قابل قبولی دارم';
                        showModalBottomSheet(
                          useSafeArea: true,
                          context: context,
                          builder: (context) {
                            return Container(
                              width: getAllWidth(context),
                              child: Padding(
                                padding: EdgeInsets.all(8.sp),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'حسین خشای پور',
                                      style: TextStyle(
                                        fontFamily: 'sahelbold',
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.sp,
                                    ),
                                    Text(
                                      'ایران - تهران',
                                      style: TextStyle(
                                        fontFamily: 'sahelbold',
                                        fontSize: 10.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.sp,
                                    ),
                                    Text(
                                      description,
                                      style: TextStyle(
                                        fontFamily: 'sahelbold',
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        final Uri smsLaunchUri = Uri(
                                          scheme: 'sms',
                                          path: '09120776658',
                                          queryParameters: <String, String>{
                                            'body':
                                                Uri.encodeComponent('سلام !'),
                                          },
                                        );
                                      },
                                      child: const Text(
                                        '09120776658',
                                        style: TextStyle(
                                          fontFamily: 'sahelbold',
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'بازگشت',
                                        style: TextStyle(
                                          fontFamily: 'sahelbold',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Text(
                            'خروج از حساب کاربری',
                            style: TextStyle(
                              fontFamily: 'sahelbold',
                              fontSize: 12.sp,
                              color: Colors.red,
                            ),
                          ),
                          const Icon(
                            Icons.logout,
                            color: primaryColor,
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_rounded),
                      onTap: () {
                        showModalBottomSheet(
                          useSafeArea: true,
                          context: context,
                          builder: (context) {
                            return Container(
                              width: getAllWidth(context),
                              height: Responsive.isTablet(context) ? 300 : 250,
                              child: BlocProvider(
                                create: (context) => AuthBloc(
                                  AuthRepository(),
                                ),
                                child: BlocConsumer<AuthBloc, AuthState>(
                                  listener: (context, state) {
                                    if (state is LogoutCompletedState) {
                                      Navigator.pop(context);
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        SplashScreen.screenId,
                                        (route) => false,
                                      );
                                    }
                                    if (state is AuthErrorState) {}
                                  },
                                  builder: (context, state) {
                                    if (state is AuthLoadingState) {
                                      return const CircularProgressIndicator(
                                        color: primaryColor,
                                      );
                                    }
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 10.sp,
                                        ),
                                        Text(
                                          'آیا از خروج حساب کاربری اطمینان دارید؟',
                                          style: TextStyle(
                                            fontFamily: 'sahelbold',
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.sp,
                                        ),
                                        Text(
                                          'این کار باعث حذف حساب شما میشود',
                                          style: TextStyle(
                                            fontFamily: 'sahelbold',
                                            fontSize: 9.sp,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.sp,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                fixedSize: const Size(200, 50),
                                              ),
                                              onPressed: () {
                                                BlocProvider.of<AuthBloc>(
                                                        context)
                                                    .add(CallLogOutEvent());
                                                Navigator.pushNamed(context,
                                                    SplashScreen.screenId);
                                              },
                                              child: const Text(
                                                'خروج از حساب کاربری',
                                                style: TextStyle(
                                                  fontFamily: 'sahelbold',
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.sp,
                                            ),
                                            OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                fixedSize: const Size(200, 50),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'بازگشت',
                                                style: TextStyle(
                                                  fontFamily: 'sahelbold',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    ListTile(
                      title: Text(
                        'تغییر تم',
                        style: TextStyle(
                          fontFamily: 'sahelbold',
                          fontSize: 13.sp,
                        ),
                      ),
                      trailing: BlocProvider.of<ChangethemeCubit>(context)
                                  .customTheme ==
                              CustomTheme.lightTheme
                          ? const Icon(Icons.dark_mode)
                          : const Icon(Icons.light_mode),
                      onTap: () {
                        BlocProvider.of<ChangethemeCubit>(context)
                            .changeTheme();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
