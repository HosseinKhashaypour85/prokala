import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prokalaproject/const/theme/colors.dart';
import 'package:prokalaproject/features/category_features/screens/all_category_screen.dart';
import 'package:prokalaproject/features/public_features/widget/error_screen_widget.dart';
import 'package:prokalaproject/features/search_features/logic/search_bloc.dart';
import 'package:prokalaproject/features/search_features/model/search_model.dart';
import 'package:prokalaproject/features/search_features/services/search_repository_services.dart';

import '../../../const/responsive.dart';
import '../../../const/shape/media_query.dart';
import '../../product_features/screens/product_details_screen.dart';
import '../../public_features/functions/number_to_three.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  static const String screenId = '/search_screen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  Future<bool> onWillPop() async {
  var currentFocus = FocusScope.of(context);
  if(!currentFocus.hasPrimaryFocus || currentFocus.focusedChild !=null){
    currentFocus.focusedChild!.unfocus();
    return false;
  } else{
    return true;
  }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(
        SearchRepositoryServices(),
      ),
      child: PopScope(
        canPop: true,
        onPopInvoked: (didPop) async {
           onWillPop();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Builder(builder: (context) {
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    child: TextField(
                      controller: _textEditingController,
                      style: TextStyle(fontFamily: 'sahelbold'),
                      textAlignVertical: TextAlignVertical.center,
                      textDirection: TextDirection.rtl,
                      maxLength: 30,
                      decoration: InputDecoration(
                        filled: true,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.withOpacity(0.7),
                        ),
                        counter: const SizedBox.shrink(),
                      ),
                      onSubmitted: (value) {
                        if (_textEditingController.text.trim().length > 1) {
                          BlocProvider.of<SearchBloc>(context).add(
                              CallSearchEvent(search: _textEditingController.text));
                        }
                      },
                      onTap: () {
                        if (_textEditingController.text.isNotEmpty &&
                            !_textEditingController.text.endsWith(' ')) {
                          _textEditingController.text =
                              _textEditingController.text + ' ';
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, state) {
                        if (state is SearchLoadingState) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          );
                        }
                        if (state is SearchCompletedState) {
                          return state.searchModel.products == null
                              ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/dontknow.png'),
                              Text(
                                'محصول مورد نظر پیدا نشد',
                                style: TextStyle(
                                  fontFamily: 'sahelbold',
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                          )
                              : ListView.builder(
                            itemCount: state.searchModel.products!.length,
                            itemBuilder: (context, index) {
                              final helper =
                              state.searchModel.products![index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    ProductDetailsScreen.screenId,
                                    arguments: {
                                      'product_id': helper.productId!
                                    },
                                  );
                                },
                                child: Container(
                                  width: getAllWidth(context),
                                  height: Responsive.isTablet(context)
                                      ? 230
                                      : 150,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: FadeInImage(
                                          placeholder: const AssetImage(
                                              'assets/images/logo2.png'),
                                          image: NetworkImage(
                                              helper.productImage!),
                                          imageErrorBuilder: (context,
                                              error, stackTrace) =>
                                              Image.asset(
                                                'assets/images/logo2.png',
                                                width: getWidth(context, 0.3),
                                              ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: getWidth(context, 0.03),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceAround,
                                          children: [
                                            Text(
                                              helper.productTitle!,
                                              style: TextStyle(
                                                  fontFamily: 'sahelbold',
                                                  fontSize: 12.sp),
                                            ),
                                            Text(
                                              getFormatPrice(helper
                                                  .productPrice!) +
                                                  'تومان',
                                              style: TextStyle(
                                                  fontFamily: 'sahelbold',
                                                  fontSize: 10.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        if (state is SearchErrorState) {
                          return ErrorScreenWidget(
                            errorMsg: state.error.errorMsg!,
                            function: () {
                              BlocProvider.of<SearchBloc>(context).add(
                                  CallSearchEvent(
                                      search: _textEditingController.text));
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}