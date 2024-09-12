import 'package:flutter/cupertino.dart';

@immutable
abstract class CartEvent {}

class AddToCartEvent extends CartEvent {
  final String id;
  AddToCartEvent(this.id);
}

class CallShowCartEvent extends CartEvent {}

class ChangeCartCount extends CartEvent{
  final String productId;
  final String cartId;
  final String count;
  ChangeCartCount({required this.productId, required this.cartId, required this.count});
}

//delete item

class DeleteItemEvent extends CartEvent{
  final String cartId;
  DeleteItemEvent(this.cartId);
}