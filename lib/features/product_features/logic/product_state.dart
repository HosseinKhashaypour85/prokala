part of 'product_bloc.dart';

@immutable
abstract class ProductState {}
class ProductInitial extends ProductState {}
class ProductLoadingState extends ProductState {}

class ProductCompletedState extends ProductState {
  final ProductModel productModel;
  ProductCompletedState(this.productModel);
}

class ProductErrorState extends ProductState {
  final ErrorMessageClass error;
  ProductErrorState({required this.error});
}
