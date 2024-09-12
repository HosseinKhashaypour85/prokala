import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prokalaproject/const/responsive.dart';
import 'package:prokalaproject/const/shape/border_radius.dart';
import 'package:prokalaproject/const/shape/media_query.dart';
import 'package:prokalaproject/const/theme/colors.dart';
import 'package:prokalaproject/features/home_features/logic/cubit/home_cubit.dart';
import 'package:prokalaproject/features/home_features/model/home_model.dart';
import 'package:prokalaproject/features/product_features/screens/product_details_screen.dart';
import 'package:prokalaproject/features/public_features/logic/token_checker/token_check_cubit.dart';
import 'package:prokalaproject/features/services/home_repository.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../authentication_features/logic/auth_bloc.dart';
import '../../public_features/functions/number_to_three.dart';
import '../../public_features/functions/secure_storage.dart';
import '../logic/bloc/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String screenId = '/home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(CallHomeEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        body: SearchBarWidget(theme: theme, context: context),
      ),
    );
  }
}

class SearchBarWidget extends StatelessWidget {
  final ThemeData theme;
  final BuildContext context;

  const SearchBarWidget({
    Key? key,
    required this.theme,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: primaryColor,
      onRefresh: () async {
        BlocProvider.of<HomeBloc>(context).add(CallHomeEvent());
      },
      child: CustomScrollView(
        slivers: [
          SecondSearchBarWidget(theme: theme),
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoadingState) {
                      return ShimmerLoadingWidget();
                    }
                    if (state is HomeCompleted) {
                      HomeModel homeModel = state.homeModel;
                      return HomeContentWidget(
                        homeModel: homeModel,
                        list: [],
                      );
                    }
                    if (state is HomeError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/dontknow.png',
                              width: getAllWidth(context),
                            ),
                            Text(
                              state.error.errorMsg.toString(),
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'sahelbold',
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<HomeBloc>(context)
                                    .add(CallHomeEvent());
                              },
                              child: Text(
                                'تلاش مجدد',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'sahelbold',
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SecondSearchBarWidget extends StatelessWidget {
  const SecondSearchBarWidget({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      forceElevated: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      toolbarHeight: Responsive.isTablet(context) ? 80 : 85,
      pinned: true,
      flexibleSpace: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getWidth(context, 0.02), vertical: 8.sp),
        child: GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(5),
            height: Responsive.isTablet(context) ? 60 : 45,
            decoration: BoxDecoration(
              color: textFieldColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Row(
              children: [
                Icon(Icons.search),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'جستجو در',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'sahelbold',
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'پروکالا',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'sahelbold',
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShimmerLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 200,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContentWidget extends StatelessWidget {
  final HomeModel homeModel;
  final List<dynamic> list;

  const HomeContentWidget(
      {Key? key, required this.homeModel, required this.list})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselWidget(homeModel: homeModel),
        SizedBox(
          height: 20.sp,
        ),
        BrandsWidget(homeModel: homeModel),
        SizedBox(
          height: 20.sp,
        ),
        AmazingOffersWidget(homeModel: homeModel),
        SizedBox(
          height: 20.sp,
        ),
        SizedBox(
          height: 20.sp,
        ),
        SizedBox(
          height: 20.sp,
        ),
        CategoryBanner(homeModel: homeModel),
        SizedBox(
          height: 20.sp,
        ),
        ProductListWidget(
          list: homeModel.random!,
          title: 'محصولات پرفروش',
        ),
        ProductListWidget(
          list: homeModel.colOne!,
          title: homeModel.colOneName,
        ),
        ProductListWidget(
          list: homeModel.colTwo!,
          title: homeModel.colTwoName,
        ),
        ProductListWidget(
          list: homeModel.colThree!,
          title: homeModel.colThreeName,
        ),
        ProductListWidget(
          list: homeModel.colFour!,
          title: homeModel.colFourName,
        ),
        ProductListWidget(
          list: homeModel.colFive!,
          title: homeModel.colFiveName,
        ),
        SizedBox(
          height: 20.sp,
        ),
        TopBanners(homeModel: homeModel),
        SizedBox(
          height: 20.sp,
        ),
      ],
    );
  }
}

class TopBanners extends StatelessWidget {
  final HomeModel homeModel;

  const TopBanners({super.key, required this.homeModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getAllWidth(context),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: homeModel.twoBanner!.length,
        itemBuilder: (context, index) {
          final helper = homeModel.twoBanner![index];
          return GestureDetector(
            onTap: () async {
              final url = homeModel.twoBanner![index].link;
              if (await canLaunchUrlString(url!)) {
                launchUrlString(url);
              }
            },
            child: Padding(
              padding: EdgeInsets.all(8.sp),
              child: ClipRRect(
                borderRadius: getBorderRadiusFunc(8),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/images/logo2.png'),
                  image: NetworkImage(helper.image!),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CategoryBanner extends StatelessWidget {
  final HomeModel homeModel;

  const CategoryBanner({super.key, required this.homeModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: homeModel.categoryBanner!.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.75,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20),
      itemBuilder: (context, index) {
        final helper = homeModel.categoryBanner![index];
        return ClipRRect(
          borderRadius: getBorderRadiusFunc(12),
          child: GestureDetector(
            onTap: () async {
              final url = homeModel.categoryBanner![index].link;
              if (await canLaunchUrlString(url!)) {
                launchUrlString(url);
              }
            },
            child: FadeInImage(
              placeholder: const AssetImage('assets/images/logo2.png'),
              image: NetworkImage(helper.image!),
              fit: BoxFit.cover,
              width: getAllWidth(context),
              height: getWidth(context, 0.32),
            ),
          ),
        );
      },
    );
  }
}

class ProductListWidget extends StatelessWidget {
  final List<dynamic> list;
  final String? title;

  const ProductListWidget({Key? key, required this.list, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(10.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title!,
            style: TextStyle(
              color: primaryColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'sahelbold',
            ),
            textAlign: TextAlign.right,
          ),
          Container(
            width: 500,
            height: 300,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: list!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) {
                final helper = list![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      ProductDetailsScreen.screenId,
                      arguments: {
                        'product_id': list[index].id,
                      },
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10.sp),
                    child: FadeInImage(
                      placeholder: const AssetImage(
                        'assets/images/logo2.png',
                      ),
                      image: NetworkImage(
                        helper.image!,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'مشاهده همه',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'sahelbold',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BrandsWidget extends StatelessWidget {
  const BrandsWidget({
    super.key,
    required this.homeModel,
  });

  final HomeModel homeModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: getAllWidth(context),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: homeModel.brands!.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 50,
          mainAxisSpacing: 50,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              final url = homeModel.brands![index].link;
              if (await canLaunchUrlString(url!)) {
                launchUrlString(url);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                decoration: ShapeDecoration(
                  color: theme.scaffoldBackgroundColor,
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  shadows: [
                    BoxShadow(
                      color: theme.shadowColor,
                      blurRadius: 25,
                      spreadRadius: -12,
                      offset: const Offset(0.0, 15),
                    ),
                  ],
                ),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/images/logo2.png'),
                  image: NetworkImage(
                    homeModel.brands![index].image!,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CarouselWidget extends StatelessWidget {
  const CarouselWidget({
    super.key,
    required this.homeModel,
  });

  final HomeModel homeModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<HomeCubit, int>(
        builder: (context, state) {
          return Column(
            children: [
              CarouselSlider.builder(
                itemCount: homeModel.sliders!.length,
                itemBuilder: (context, index, realIndex) {
                  return GestureDetector(
                    onTap: () async {
                      final url = homeModel.sliders![index].link;
                      if (await canLaunchUrlString(url!)) {
                        await launchUrlString(url,
                            mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage(
                          placeholder:
                              const AssetImage('assets/images/logo2.png'),
                          image: NetworkImage(
                            homeModel.sliders![index].image!,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  height: getWidth(context, 0.42),
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    BlocProvider.of<HomeCubit>(context)
                        .changeCurrentIndex(index);
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              AnimatedSmoothIndicator(
                activeIndex: BlocProvider.of<HomeCubit>(context).CurrentIndex,
                count: homeModel.sliders!.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: primaryColor,
                  dotWidth: 8.5.sp,
                  dotHeight: 7.5.sp,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class AmazingOffersWidget extends StatelessWidget {
  final HomeModel homeModel;

  const AmazingOffersWidget({
    super.key,
    required this.homeModel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: getAllWidth(context),
      height: getWidth(context, 0.65),
      color: Colors.red,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Container(
              width: getWidth(context, 0.25),
              margin: EdgeInsets.symmetric(
                horizontal: 10.sp,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'پیشنهادات ویژه',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'sahelbold',
                        color: Colors.white),
                  ),
                  FadeInImage(
                    placeholder: AssetImage(
                      'assets/images/logo2.png',
                    ),
                    image: AssetImage(
                      'assets/images/amazing/amazing_box.png',
                    ),
                  ),
                ],
              ),
            ),
            AmazingWidget(homeModel: homeModel, theme: theme),
          ],
        ),
      ),
    );
  }
}

class AmazingWidget extends StatelessWidget {
  const AmazingWidget({
    super.key,
    required this.homeModel,
    required this.theme,
  });

  final HomeModel homeModel;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: homeModel.amazing!.length,
      itemBuilder: (context, index) {
        final helper = homeModel.amazing![index];
        return Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: getBorderRadiusFunc(5),
          ),
          width: getWidth(context, 0.375),
          child: Column(
            children: [
              FadeInImage(
                placeholder: const AssetImage('assets/images/logo2.png'),
                image: NetworkImage(helper.image!),
                fit: BoxFit.cover,
                width: getWidth(context, 0.275),
                height: getWidth(context, 0.275),
              ),
              Text(
                helper.title!,
                style: const TextStyle(fontFamily: 'sahelbold'),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      getFormatPrice(helper.defaultPrice!),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      getFormatPrice(helper.percentPrice!.toString()),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
