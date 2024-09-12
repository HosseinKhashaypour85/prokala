import 'package:dio/dio.dart';
import 'package:prokalaproject/features/public_features/functions/secure_storage.dart';

import '../../../const/connection.dart';

class ProductApiServices{
  final Dio _dio = Dio();

  Future<Response> CallProductApi(String id)async{
    final token = await SecureStorageClass().getUserToken()??false;
    print('------------------------------------------------------------------------------');
    print(token);
    final Response response = await _dio.get('$apiUrl/product/$id/$token');
    return response;
  }
}