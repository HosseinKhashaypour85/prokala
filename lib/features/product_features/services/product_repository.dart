import 'package:dio/dio.dart';
import 'package:prokalaproject/features/product_features/model/product_model.dart';
import 'package:prokalaproject/features/product_features/services/product_api_services.dart';

class ProductRepository{
  final ProductApiServices _apiServices = ProductApiServices();
  Future<ProductModel>CallDetailsProduct(String id)async{
   final Response response = await _apiServices.CallProductApi(id);
   ProductModel productModel = ProductModel.fromJson(response.data);
   return productModel;
  }
}