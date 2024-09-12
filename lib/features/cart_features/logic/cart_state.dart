part of 'cart_bloc.dart';

@immutable
abstract class CartState {}
class CartInitial extends CartState {}

class CartLoadingState extends CartState{}

class CartCompletedState extends CartState{}

class CartErrorState extends CartState{
  final ErrorMessageClass error;
  CartErrorState({required this.error});
}

//show products in cart
class ShowCartCompleted extends CartState{
  final CartModel cartModel;
  ShowCartCompleted(this.cartModel);
}

// change counts of products(+ , -)
class ChangeCountCompleted extends CartState{
 final String totalPrice;
 ChangeCountCompleted(this.totalPrice);
}

//delete item from cart

class DeleteCompletedState extends CartState{}