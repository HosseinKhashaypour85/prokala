import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:prokalaproject/features/product_features/model/product_model.dart';
import 'package:prokalaproject/features/public_features/error/error_message_class.dart';

import '../../public_features/error/error_exception.dart';
import '../services/product_repository.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc(this.productRepository) : super(ProductInitial()) {
    on<CallProductEvent>(_CallProductsDetails);
  }

  List<String>newGallery = [];

  FutureOr<void> _CallProductsDetails(
      CallProductEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoadingState());
    try {
      final ProductModel productModel = await productRepository.CallDetailsProduct(event.id);
      emit(ProductCompletedState(productModel));
      if(productModel.gallery !=null){
        newGallery.add(productModel.product!.image!);
        for(int i =0 ; i<productModel.gallery!.length; i++){
          newGallery.add(productModel.gallery![i].path!);
        }
      }
    } on DioException catch (e) {
      emit(ProductErrorState(
          error: ErrorMessageClass(errorMsg: ErrorExceptions().fromError(e))));
    }
  }
}
