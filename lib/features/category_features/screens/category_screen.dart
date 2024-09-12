import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prokalaproject/const/shape/border_radius.dart';
import 'package:prokalaproject/const/shape/media_query.dart';
import 'package:prokalaproject/features/category_features/logic/bloc/category_bloc.dart';
import 'package:prokalaproject/features/category_features/model/category_model.dart';
import 'package:prokalaproject/features/category_features/services/category_repository.dart';
import 'package:prokalaproject/features/home_features/screens/home_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../../../const/responsive.dart';
import '../../../const/theme/colors.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  static const String ScreenId = '/category_screen';

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) =>
          CategoryBloc(CategoryRepository())..add(CallCategory()),
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoadingState) {
            return const CategoryLoading();
          }
          if (state is CategoryCompletedState) {
            CategoryModel categoryModel = state.categoryModel;
            return CategoryPageContent(
              theme: theme,
              categoryModel: categoryModel,
            );
          }
          if (state is CategoryErrorState) {}
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class CategoryPageContent extends StatelessWidget {
  const CategoryPageContent({
    super.key,
    required this.theme,
    required this.categoryModel,
  });

  final ThemeData theme;
  final CategoryModel categoryModel;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SecondSearchBarWidget(theme: theme),
        SliverList(
          delegate: SliverChildListDelegate.fixed([
            Container(
              width: getAllWidth(context),
              height: getAllHeight(context),
              child: ListView.builder(
                itemCount: categoryModel.category!.length,
                itemBuilder: (context, CatIndex) {
                  final CategoryHelper = categoryModel.category![CatIndex];
                  return Column(
                    children: [
                      Text(
                        CategoryHelper.title!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'sahelbold',
                          fontSize: 14.sp,
                        ),
                      ),
                      Container(
                        width: getAllWidth(context),
                        height: getWidth(context, 0.45),
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: categoryModel
                              .category![CatIndex].subCategory!.length,
                          itemBuilder: (context, SubCatIndex) {
                            final SubCatHelper =
                                CategoryHelper.subCategory![SubCatIndex];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  SubCatHelper.image == null
                                      ? Image.asset(
                                          'assets/images/logo2.png',
                                          width: getWidth(context, 0.275),
                                          height: getWidth(context, 0.325),
                                        )
                                      : FadeInImage(
                                          placeholder: const AssetImage(
                                              'assets/images/logo2.png'),
                                          image: NetworkImage(
                                            SubCatHelper.image!,
                                          ),
                                          width: getWidth(context, 0.275),
                                          height: getWidth(context, 0.325),
                                          imageErrorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                            width: getWidth(context, 0.275),
                                            height: getWidth(context, 0.325),
                                          ),
                                        ),
                                  Text(
                                    SubCatHelper.title!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'sahelbold',
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ]),
        ),
      ],
    );
  }
}

class CategoryLoading extends StatelessWidget {
  const CategoryLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: EdgeInsets.all(10.sp),
        child: Wrap(
          runSpacing: 10.sp,
          children: const [
            ShimmerContainer(),
            ShimmerContainer(),
            ShimmerContainer(),
            ShimmerContainer(),
            ShimmerContainer(),
            ShimmerContainer(),
            ShimmerContainer(),
            ShimmerContainer(),
            ShimmerContainer(),
            ShimmerContainer(),
            ShimmerContainer(),
            ShimmerContainer(),
            ShimmerContainer(),
          ],
        ),
      ),
    );
  }
}

class ShimmerContainer extends StatelessWidget {
  const ShimmerContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.sp),
      width: getWidth(context, 0.28),
      height: getWidth(context, 0.4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: getBorderRadiusFunc(10),
      ),
    );
  }
}
