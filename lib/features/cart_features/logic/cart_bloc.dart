import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:prokalaproject/features/public_features/error/error_message_class.dart';

import '../../public_features/error/error_exception.dart';
import '../model/cart_model.dart';
import '../services/cart_respository.dart';
import 'cart_event.dart';

part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRespository cartRespository;

  CartBloc(this.cartRespository) : super(CartInitial()) {
    on<AddToCartEvent>(_addTocart);
    on<CallShowCartEvent>(_showCartApi);
    on<ChangeCartCount>(_changeCartCount);
    on<DeleteItemEvent>(_deleteItem);
  }

  CartModel cartModel = CartModel();
  String totalPrice = '0';

  FutureOr<void> _addTocart(
      AddToCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    try {
      cartRespository.addToCart(event.id);
      emit(CartCompletedState());
      emit(CartCompletedState());
    } on DioException catch (e) {
      emit(CartErrorState(
          error: ErrorMessageClass(errorMsg: ErrorExceptions().fromError(e))));
    }
  }

  FutureOr<void> _showCartApi(
      CallShowCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    try {
      cartModel = await cartRespository.CallShowCart();
      emit(ShowCartCompleted(cartModel));
    } on DioException catch (e) {
      emit(CartErrorState(
          error: ErrorMessageClass(errorMsg: ErrorExceptions().fromError(e))));
    }
  }

  FutureOr<void> _changeCartCount(
      ChangeCartCount event, Emitter<CartState> emit) async {
    emit(CartLoadingState());

    Cart currentItemCount = cartModel.cart!
        .firstWhere((element) => element.cartId == int.parse(event.cartId));
    try {
      totalPrice = await cartRespository.changeCountApi(
          pId: event.productId, cartId: event.cartId, NewCount: event.count);
      currentItemCount.count = event.count;

      emit(ChangeCountCompleted(totalPrice));
      emit(ShowCartCompleted(cartModel));
    } on DioException catch (e) {
      emit(CartErrorState(
          error: ErrorMessageClass(errorMsg: ErrorExceptions().fromError(e))));
    }
  }

  FutureOr<void> _deleteItem(
      DeleteItemEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    try {
      await cartRespository.deleteProductApi(event.cartId);

      cartModel.cart!.removeWhere((element) => element.cartId == int.parse(event.cartId));

      emit(DeleteCompletedState());
      emit(ShowCartCompleted(cartModel));
    } on DioException catch (e) {
      emit(CartErrorState(
          error: ErrorMessageClass(errorMsg: ErrorExceptions().fromError(e))));
    }
  }
}
