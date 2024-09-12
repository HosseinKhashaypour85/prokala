import 'package:dio/dio.dart';
import 'package:prokalaproject/features/cart_features/services/cart_api_services.dart';

import '../model/cart_model.dart';

class CartRespository{
  final CartApiServices _apiServices = CartApiServices();
  Future<void>addToCart(String id)async{
    final Response response = await _apiServices.CallCartApi(id);
  }
  Future<CartModel>CallShowCart()async{
    final Response response = await _apiServices.callShowCart();
    CartModel cartModel = CartModel.fromJson(response.data);
    return cartModel;
  }
  Future<String>changeCountApi({required String pId, required String cartId , required String NewCount})async{
    final Response response = await _apiServices.changeCountApi(pId: pId, cartId: cartId, NewCount: NewCount);
    return response.data['total_cart'].toString();
  }
  Future<void>deleteProductApi(String cartId)async{
    await _apiServices.deleteProductApi(cartId);
  }
}