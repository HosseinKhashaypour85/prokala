import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prokalaproject/const/theme/theme.dart';
import 'package:prokalaproject/features/authentication_features/screens/auth_screen.dart';
import 'package:prokalaproject/features/cart_features/logic/cart_bloc.dart';
import 'package:prokalaproject/features/cart_features/services/cart_respository.dart';
import 'package:prokalaproject/features/category_features/logic/bloc/category_bloc.dart';
import 'package:prokalaproject/features/category_features/screens/category_screen.dart';
import 'package:prokalaproject/features/category_features/services/category_repository.dart';
import 'package:prokalaproject/features/comments_features/screen/add_comment_screen.dart';
import 'package:prokalaproject/features/comments_features/screen/comment_screen.dart';
import 'package:prokalaproject/features/home_features/logic/cubit/home_cubit.dart';
import 'package:prokalaproject/features/home_features/logic/bloc/home_bloc.dart';
import 'package:prokalaproject/features/home_features/screens/home_screen.dart';
import 'package:prokalaproject/features/intro_features/logic/intro_cubit.dart';
import 'package:prokalaproject/features/intro_features/screens/intro_screen.dart';
import 'package:prokalaproject/features/intro_features/screens/splash_screen.dart';
import 'package:prokalaproject/features/intro_features/screens/unknown_screen.dart';
import 'package:prokalaproject/features/product_features/logic/cubit/product_carousel_cubit.dart';
import 'package:prokalaproject/features/product_features/logic/product_bloc.dart';
import 'package:prokalaproject/features/product_features/screens/product_details_screen.dart';
import 'package:prokalaproject/features/product_features/services/product_repository.dart';
import 'package:prokalaproject/features/public_features/logic/bottom_nav_cubit.dart';
import 'package:prokalaproject/features/public_features/logic/token_checker/token_check_cubit.dart';
import 'package:prokalaproject/features/public_features/screens/bottom_nav_bar_screen.dart';
import 'package:prokalaproject/features/services/home_repository.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => IntroCubit(),
          ),
          BlocProvider(
            create: (context) => BottomNavCubit(),
          ),
          BlocProvider(
            create: (context) => HomeBloc(HomeRepository()),
          ),
          BlocProvider(
            create: (context) => HomeCubit(),
          ),
          BlocProvider(
            create: (context) => CategoryBloc(CategoryRepository()),
          ),
          BlocProvider(
            create: (context) => TokenCheckCubit(),
          ),
          BlocProvider(
            create: (context) => ProductCarouselCubit(),
          ),
          BlocProvider(
            create: (context) => ProductBloc(ProductRepository()),
          ),
          BlocProvider(
            create: (context) => CartBloc(CartRespository()),
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          // theme: ,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('fa'), // Spanish
          ],
          theme: CustomTheme.lightTheme,
          // home: SplashScreen(),
          onUnknownRoute: (settings) => MaterialPageRoute(
            builder: (context) => const UnknownScreen(),
          ),
          initialRoute: SplashScreen.screenId,
          routes: {
            SplashScreen.screenId: (context) => const SplashScreen(),
            IntroScreen.screenId: (context) => const IntroScreen(),
            HomeScreen.screenId: (context) => const HomeScreen(),
            BottomNavBarScreen.screenId: (context) =>
                const BottomNavBarScreen(),
            CategoryScreen.ScreenId: (context) => const CategoryScreen(),
            AuthScreen.ScreenId: (context) => const AuthScreen(),
            ProductDetailsScreen.screenId: (context) => const ProductDetailsScreen(),
            CommentScreen.screenId: (context) => const CommentScreen(),
            AddCommentScreen.screenId: (context) => const AddCommentScreen(),
          },
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
