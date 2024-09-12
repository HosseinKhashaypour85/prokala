import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prokalaproject/const/theme/colors.dart';
import 'package:prokalaproject/features/home_features/screens/home_screen.dart';
import 'package:prokalaproject/features/intro_features/logic/intro_cubit.dart';
import 'package:prokalaproject/features/pref/shared_pref.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../const/shape/media_query.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  static const String screenId = '/intro_screen';

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  PageController pageController = PageController(initialPage: 0);

  List<Widget> pageitem = [
    const PageViewItems(
      image: 'assets/images/intro/Apple-iPad-PNG-Free-Download.png',
      name: 'خرید و فروش آسان',
      desc: 'با اپلیکیشن پروکالا به راحتی خرید و فروش کن',
    ),
    const PageViewItems(
      image: 'assets/images/intro/iphone-x-pictures-45229.png',
      name: 'تخصص حرف اول رو میزنه !',
      desc: 'تیم پروکالا با چندین سال تجربه در این زمینه تخصص دارد',
    ),
    const PageViewItems(
      image: 'assets/images/intro/pngwing.com.png',
      name: 'پیدا کردن سریع و آسان',
      desc: 'بیش از صد هزارمحصول در پروکالا',
    ),
    const PageViewItems(
      image: 'assets/images/intro/pngwing.com1.png',
      name: 'به روز باش !',
      desc: 'با پروکالا همیشه به روز باش',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<IntroCubit, int>(
        builder: (context, state) {
          return Stack(
            children: [
              ClipPath(
                clipper: WaveClipperOne(),
                child: Container(
                  height: 120,
                  color: primaryColor,
                  child: Container(
                    height: 200,
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 400,
                      // color: Colors.blueAccent,
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: pageitem.length,
                        itemBuilder: (context, index) {
                          return pageitem[index];
                        },
                        onPageChanged: (value) {
                          BlocProvider.of<IntroCubit>(context).changeIndex(value);
                        },
                      ),
                    ),
                    SmoothPageIndicator(
                      controller: pageController, // PageController
                      count: pageitem.length,
                      axisDirection: Axis.horizontal,
                      effect: const ExpandingDotsEffect(
                        dotWidth: 10,
                        dotHeight: 10,
                        spacing: 5,
                        activeDotColor: primaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 5.sp,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(getWidth(context, 0.5), 45)),
                      onPressed: () {
                        if (BlocProvider.of<IntroCubit>(context).CurrentIndex <
                            4) {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        } else {
                          SharedPref().setIntroStatus();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            HomeScreen.screenId,
                            (route) => false,
                          );
                        }
                      },
                      child: Text(
                        BlocProvider.of<IntroCubit>(context).CurrentIndex < 3
                            ? 'مرحله بعد'
                            : 'بزن بریم',
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'sahelbold',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class PageViewItems extends StatelessWidget {
  const PageViewItems({
    super.key,
    required this.image,
    required this.name,
    required this.desc,
  });

  final String image;
  final String name;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Image.asset(
            image,
            height: 200,
          ),
          SizedBox(
            height: 10.sp,
          ),
          Text(
            name,
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: 'sahelbold',
            ),
          ),
          SizedBox(
            height: 20.sp,
          ),
          Text(
            desc,
            style: TextStyle(
              fontSize: 10.sp,
              fontFamily: 'sahelbold',
              overflow: TextOverflow.clip,
            ),
          ),
        ],
      ),
    );
  }
}
