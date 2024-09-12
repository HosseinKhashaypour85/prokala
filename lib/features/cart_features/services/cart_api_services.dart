import 'package:dio/dio.dart';
import 'package:prokalaproject/const/connection.dart';
import 'package:prokalaproject/features/public_features/functions/secure_storage.dart';

class CartApiServices{
  final Dio _dio =Dio();
  // fetch Api
  // api code :add-to-cart/5/AAhcy9msrQL6ExOvZXiljGQnzsUFY9y3xz0BZ6wi2zJgaTbUAs8aRo8EGfQkG2Hm9KPCrcf3
  Future<Response>CallCartApi(String id)async{
    final token = await SecureStorageClass().getUserToken()?? false;
    final Response response = await _dio.get('$apiUrl/add-to-cart/$id/$token');
    return response;
  }
// show cart products that we added in cart api
// api code : http://programmingshow.ir/api/api/show-cart/AAhcy9msrQL6ExOvZXiljGQnzsUFY9y3xz0BZ6wi2zJgaTbUAs8aRo8EGfQkG2Hm9KPCrcf3
Future<Response>callShowCart()async{
    final token = await SecureStorageClass().getUserToken();
    final Response response = await _dio.get('$apiUrl/show-cart/$token');
    return response;
}
// change Cart count for products
// api code :http://programmingshow.ir/api/api/cart/change-count/pId/cartId/NewCount/AAhcy9msrQL6ExOvZXiljGQnzsUFY9y3xz0BZ6wi2zJgaTbUAs8aRo8EGfQkG2Hm9KPCrcf3http://programmingshow.ir/api/api/cart/change-count/pId/cartId/NewCount/AAhcy9msrQL6ExOvZXiljGQnzsUFY9y3xz0BZ6wi2zJgaTbUAs8aRo8EGfQkG2Hm9KPCrcf3
Future<Response>changeCountApi({required String pId, required String cartId , required String NewCount})async{
  final token = await SecureStorageClass().getUserToken();
  final Response response = await _dio.get('$apiUrl/cart/change-count/$pId/$cartId/$NewCount/$token');
  return response;
}
// remove product from cart
// api code : http://programmingshow.ir/api/api/delete-one/9
Future<Response>deleteProductApi(String cartId)async{
    final Response response = await _dio.get('$apiUrl/delete-one/$cartId');
    return response;
}
}