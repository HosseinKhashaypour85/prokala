import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prokalaproject/const/responsive.dart';
import 'package:prokalaproject/const/shape/border_radius.dart';
import 'package:prokalaproject/const/shape/media_query.dart';
import 'package:prokalaproject/const/theme/colors.dart';
import 'package:prokalaproject/features/cart_features/logic/cart_bloc.dart';
import 'package:prokalaproject/features/cart_features/logic/cart_event.dart';
import 'package:prokalaproject/features/cart_features/services/cart_respository.dart';
import 'package:prokalaproject/features/public_features/functions/number_to_three.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CartBloc(CartRespository())..add(CallShowCartEvent()),
      child: BlocConsumer<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoadingState) {
            return const Center(
                child: CircularProgressIndicator(
              color: primaryColor,
            ));
          }
          if (state is ShowCartCompleted) {
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: state.cartModel.cart!.length,
                    itemBuilder: (context, index) {
                      final helper = state.cartModel.cart![index];
                      return Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.sp, vertical: 10.sp),
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.sp, vertical: 10.sp),
                        height: Responsive.isTablet(context) ? 300 : 200,
                        width: getAllWidth(context),
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: FadeInImage(
                                        placeholder: const AssetImage(
                                            'assets/images/logo2.png'),
                                        image:
                                            NetworkImage(helper.productImage!),
                                        placeholderErrorBuilder:
                                            (context, error, stackTrace) =>
                                                Container()),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10.sp,
                                        ),
                                        Text(
                                          helper.productTitle!,
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontFamily: 'sahelbold',
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.sp,
                                        ),
                                        Text(
                                          getFormatPrice(
                                                helper.productPrice!.toString(),
                                              ) +
                                              'تومان',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontFamily: 'sahelbold',
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              height: 5.sp,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: greyColor,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    getBorderRadiusFunc(7),
                                              ),
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      // increase product
                                                      BlocProvider.of<CartBloc>(
                                                              context)
                                                          .add(
                                                        ChangeCartCount(
                                                          productId: helper
                                                              .productId!
                                                              .toString(),
                                                          cartId: helper.cartId!
                                                              .toString(),
                                                          count: (int.parse(helper
                                                                      .count!) +
                                                                  1)
                                                              .toString(),
                                                        ),
                                                      );
                                                    },
                                                    icon: const Icon(Icons.add),
                                                  ),
                                                  Text(
                                                    helper.count!.toString(),
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontFamily: 'sahelbold',
                                                    ),
                                                  ),
                                                  helper.count == 1
                                                      ? IconButton(
                                                          // remove
                                                          onPressed: () {
                                                            //   decrease product
                                                            BlocProvider.of<
                                                                        CartBloc>(
                                                                    context)
                                                                .add(
                                                                    DeleteItemEvent(
                                                              helper.productId!
                                                                  .toString(),
                                                            ));
                                                          },
                                                          icon: int.parse(helper
                                                                      .count!) ==
                                                                  1
                                                              ? const Icon(
                                                                  Icons
                                                                      .delete_forever,
                                                                  color: Colors
                                                                      .red,
                                                                )
                                                              : const Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                        )
                                                      : IconButton(
                                                          onPressed: () {
                                                            //   decrease product
                                                            BlocProvider.of<
                                                                        CartBloc>(
                                                                    context)
                                                                .add(
                                                              ChangeCartCount(
                                                                productId: helper
                                                                    .productId!
                                                                    .toString(),
                                                                cartId: helper
                                                                    .cartId!
                                                                    .toString(),
                                                                count: (int.parse(
                                                                            helper.count!) -
                                                                        1)
                                                                    .toString(),
                                                              ),
                                                            );
                                                          },
                                                          icon: int.parse(helper
                                                                      .count!) ==
                                                                  1
                                                              ? const Icon(
                                                                  Icons
                                                                      .delete_forever,
                                                                  color: Colors
                                                                      .red,
                                                                )
                                                              : const Icon(
                                                                  Icons.remove,
                                                                ),
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.sp,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'هزینه ارسال',
                                              style: TextStyle(
                                                fontFamily: 'sahelbold',
                                                fontSize: 12.sp,
                                                color: Colors.green,
                                              ),
                                            ),
                                            helper.deliveryPrice != 0
                                                ? Text(
                                                    getFormatPrice(
                                                          helper.deliveryPrice!
                                                              .toString(),
                                                        ) +
                                                        'تومان',
                                                    style: TextStyle(
                                                      fontFamily: 'sahelbold',
                                                      fontSize: 12.sp,
                                                      color: Colors.green,
                                                    ),
                                                  )
                                                : Text(
                                                    'ارسال رایگان',
                                                    style: TextStyle(
                                                      fontFamily: 'sahelbold',
                                                      fontSize: 12.sp,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          'ادامه خرید',
                          style: TextStyle(
                            fontFamily: 'sahelbold',
                          ),
                        ),
                      ),
                      Text(
                        BlocProvider.of<CartBloc>(context).totalPrice.isEmpty
                            ? getFormatPrice(
                                    state.cartModel.cartTotal!.toString()) +
                                'تومان'
                            : getFormatPrice(BlocProvider.of<CartBloc>(context)
                                    .totalPrice) +
                                'تومان',
                        style:
                            TextStyle(fontSize: 12.sp, fontFamily: 'sahelbold'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          if (state is CartErrorState) {
            return Text(state.error.errorMsg!);
          }
          return const SizedBox.shrink();
        },
        listener: (context, state) {},
      ),
    );
  }
}
