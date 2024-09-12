import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prokalaproject/const/shape/media_query.dart';
import 'package:prokalaproject/const/shape/shape.dart';
import 'package:prokalaproject/features/cart_features/logic/cart_bloc.dart';
import 'package:prokalaproject/features/cart_features/services/cart_respository.dart';
import 'package:prokalaproject/features/comments_features/screen/comment_screen.dart';
import 'package:prokalaproject/features/favorite_feautures/logic/fav_button_bloc.dart';
import 'package:prokalaproject/features/favorite_feautures/services/favorite_repository.dart';
import 'package:prokalaproject/features/product_features/logic/cubit/product_carousel_cubit.dart';
import 'package:prokalaproject/features/product_features/logic/product_bloc.dart';
import 'package:prokalaproject/features/product_features/services/product_repository.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:prokalaproject/features/public_features/functions/number_to_three.dart';
import 'package:prokalaproject/features/public_features/logic/token_checker/token_check_cubit.dart';
import 'package:prokalaproject/features/public_features/widget/snack_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../const/responsive.dart';
import '../../../const/theme/colors.dart';
import '../../cart_features/logic/cart_event.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  static const screenId = '/product_detail_screen';

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreen();
}

class _ProductDetailsScreen extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool status;
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return SafeArea(
      child: Scaffold(
        body: BlocProvider(
          create: (context) => ProductBloc(ProductRepository())
            ..add(CallProductEvent(arguments['product_id'].toString())),
          child: BlocConsumer<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }
              if (state is ProductCompletedState) {
                final helper = state.productModel;
                final CrouselHelper =
                    BlocProvider.of<ProductBloc>(context).newGallery;
                return Column(
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: Navigator.of(context).pop,
                              icon: const Icon(Icons.arrow_back),
                            ),
                            FavoriteButton(
                              id: arguments['product_id'].toString(),
                              status: helper.fav!,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.sp, vertical: 10.sp),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //gallery
                              ProductCarousels(carouselHelper: CrouselHelper),
                              Text(
                                helper.product!.title!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'sahelbold',
                                  fontSize: 15.sp,
                                ),
                              ),
                              SizedBox(
                                height: 2.5.sp,
                              ),
                              const Divider(),

                              ExpandableText(
                                helper.product!.productBody!,
                                expandText: 'نمایش بیشتر',
                                collapseText: 'نمایش کمتر',
                                maxLines: 4,
                                linkColor: primaryColor,
                                style: TextStyle(
                                  fontFamily: 'sahelbold',
                                  fontSize: 12.sp,
                                ),
                              ),
                              SizedBox(
                                height: 3.sp,
                              ),
                              // user comments column

                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    CommentScreen.screenId,
                                    arguments: {'product_id': arguments['product_id']},
                                  );
                                },
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'دیدگاه های شما',
                                          style: TextStyle(
                                            fontFamily: 'sahelbold',
                                            fontSize: 13.sp,
                                          ),
                                        ),
                                        helper.userComments!.isEmpty
                                            ? SizedBox.shrink()
                                            : Row(
                                                children: [
                                                  Text(
                                                    'تعداد دیگاه ${helper.userComments!.length}',
                                                    style: TextStyle(
                                                      fontSize: 13.sp,
                                                      color: primary2Color,
                                                      fontFamily: 'sahelbold',
                                                    ),
                                                  )
                                                ],
                                              ),
                                        //   Listview builder for comments
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.sp,
                                    ),
                                    helper.userComments!.isEmpty
                                        ? SizedBox.shrink()
                                        : Container(
                                            width: getAllWidth(context),
                                            height: 200.sp,
                                            child: ListView.builder(
                                              itemCount:
                                                  helper.userComments!.length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  width:
                                                      getWidth(context, 0.55),
                                                  padding: EdgeInsets.all(10),
                                                  child: Card(
                                                    shape: getShapeFunc(10),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            helper
                                                                .userComments![
                                                                    index]
                                                                .fullName!,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'sahelbold',
                                                                fontSize:
                                                                    12.sp),
                                                          ),
                                                          Text(
                                                            helper
                                                                .userComments![
                                                                    index]
                                                                .comment!,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'sahelbold',
                                                                fontSize:
                                                                    12.sp),
                                                          ),
                                                          Text(
                                                            helper
                                                                .userComments![
                                                                    index]
                                                                .date!,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'sahelbold',
                                                                fontSize: 10.sp,
                                                                color:
                                                                    primary2Color),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'دیدگاه خود را نسبت به این محصول ثبت کنید',
                                          style: TextStyle(
                                            fontFamily: 'sahelbold',
                                            color: Colors.black,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.arrow_forward),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BlocConsumer<CartBloc, CartState>(
                              listener: (context, state) {
                                if (state is CartErrorState) {
                                  getSnackBarWidget(
                                    context,
                                    state.error.errorMsg!,
                                    Colors.red,
                                  );
                                }
                                if (state is CartCompletedState) {
                                  getSnackBarWidget(
                                    context,
                                    'محصول با موفقیت اضافه شد',
                                    Colors.green,
                                  );
                                  helper.checkCart = true;
                                }
                              },
                              builder: (context, state) {
                                if (state is CartLoadingState) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: primaryColor,
                                    ),
                                  );
                                }

                                // استفاده از BlocBuilder برای TokenCheckCubit
                                return BlocBuilder<TokenCheckCubit,
                                    TokenCheckState>(
                                  builder: (context, state) {
                                    if (state is TokenIsLoged) {
                                      return helper.checkCart!
                                          ? const ElevatedButton(
                                              onPressed: null,
                                              child: Text(
                                                'محصول در سبد خرید است',
                                                style: TextStyle(
                                                  fontFamily: 'sahelbold',
                                                ),
                                              ),
                                            )
                                          : ElevatedButton(
                                              onPressed: () {
                                                BlocProvider.of<CartBloc>(
                                                        context)
                                                    .add(AddToCartEvent(
                                                  arguments['product_id']
                                                      .toString(),
                                                ));
                                              },
                                              child: const Text(
                                                'افزودن به سبد خرید',
                                                style: TextStyle(
                                                  fontFamily: 'sahelbold',
                                                ),
                                              ),
                                            );
                                    }
                                    return Container();
                                  },
                                );
                              },
                            ),
                            helper.percent != 0
                                ? CircleAvatar(
                                    backgroundColor: primaryColor,
                                    child: Text(
                                      helper.percent!.toString() + '%',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'sahelbold',
                                      ),
                                    ),
                                  )
                                : Container(),
                            helper.product!.defaultPrice! == 0
                                ? Text(
                                    'محصول ناموجود',
                                    style: TextStyle(
                                      fontFamily: 'sahelbold',
                                      fontSize: 12.sp,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  )
                                : Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            getFormatPrice(
                                                helper.product!.defaultPrice!),
                                            style: TextStyle(
                                              fontFamily: 'sahelbold',
                                              fontSize: 12.sp,
                                              color: Colors.black,
                                            ),
                                          ),
                                          helper.totalPrice != 0
                                              ? Text(
                                                  getFormatPrice(
                                                    helper.totalPrice
                                                        .toString(),
                                                  ),
                                                  style: TextStyle(
                                                    fontFamily: 'sahelbold',
                                                    fontSize: 12.sp,
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ],
                                  )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              if (state is ProductErrorState) {
                return const Text('data');
              }
              return const SizedBox.shrink();
            },
            listener: (context, state) {},
          ),
        ),
      ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  final String id;
  final bool status;

  const FavoriteButton({super.key, required this.id, required this.status});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TokenCheckCubit, TokenCheckState>(
      builder: (context, state) {
        if (state is TokenIsLoged) {
          return FavoriteButtonWithToken(
            id: id,
            productStatus: status,
          );
        }
        return getSnackBarWidget(
            context, 'وارد حساب کاربری خود شوید', Colors.red);
      },
    );
    ;
  }
}

class FavoriteButtonWithToken extends StatelessWidget {
  final String id;
  bool productStatus;

  FavoriteButtonWithToken(
      {super.key, required this.id, required this.productStatus});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavButtonBloc(FavoriteRepository()),
      child: BlocConsumer<FavButtonBloc, FavButtonState>(
        listener: (context, state) {
          if (state is FavButtonLoadingState) {}
          if (state is FavButtonCompletedState) {
            if (state.status) {
              getSnackBarWidget(
                  context, 'محصول به علاقه مندی ها اضافه شد ', Colors.green);
              productStatus = true;
            } else {
              getSnackBarWidget(
                  context, 'محصول از علاقه مندی ها حذف شد', Colors.red);
              productStatus = false;
            }
          }
          if (state is FavButtonErrorState) {
            const Text('data');
          }
        },
        builder: (context, state) {
          if (state is FavButtonLoadingState) {
            return const Center(
                child: CircularProgressIndicator(
              color: primaryColor,
            ));
          }
          return IconButton(
            onPressed: () {
              BlocProvider.of<FavButtonBloc>(context)
                  .add(AddToFavoriteEvent(id));
            },
            icon: productStatus
                ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
                : const Icon(
                    Icons.favorite_border_outlined,
                  ),
          );
        },
      ),
    );
  }
}

class ProductCarousels extends StatelessWidget {
  const ProductCarousels({
    super.key,
    required this.carouselHelper,
  });

  final List<String> carouselHelper;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductCarouselCubit(),
      child: BlocBuilder<ProductCarouselCubit, int>(
        builder: (context, state) {
          return Stack(
            children: [
              carouselHelper.isNotEmpty
                  ? CarouselSlider.builder(
                      itemCount: BlocProvider.of<ProductBloc>(context)
                          .newGallery
                          .length,
                      itemBuilder: (context, index, realIndex) {
                        return FadeInImage(
                          placeholder: const AssetImage(
                            'assets/images/logo2.png',
                          ),
                          image: NetworkImage(
                            carouselHelper[index],
                          ),
                          imageErrorBuilder: (context, error, stackTrace) =>
                              Container(),
                          width: getAllWidth(context),
                          placeholderErrorBuilder:
                              (context, error, stackTrace) => Container(),
                        );
                      },
                      options: CarouselOptions(
                        viewportFraction: 1,
                        height: Responsive.isTablet(context)
                            ? getWidth(context, 0.33)
                            : getWidth(context, 0.45),
                        onPageChanged: (index, value) {
                          BlocProvider.of<ProductCarouselCubit>(context)
                              .changeIndex(index);
                        },
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                      ),
                    )
                  : const Text(
                      'محصول یافت نشد دقایقی دیگر مجدد تلاش کنید',
                      style: TextStyle(
                        color: primaryColor,
                        fontFamily: 'sahelbold',
                      ),
                    ),
              Positioned(
                bottom: 0,
                left: 10,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.sp, vertical: 12.sp),
                  color: Colors.white10,
                  child: AnimatedSmoothIndicator(
                    activeIndex: BlocProvider.of<ProductCarouselCubit>(context)
                        .currentIndex,
                    count: carouselHelper.length,
                    effect: ExpandingDotsEffect(
                      dotColor: Colors.red.shade100,
                      activeDotColor: primaryColor,
                      dotWidth: 8.5.sp,
                      dotHeight: 7.5.sp,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
