import 'package:dio/dio.dart';
import 'package:prokalaproject/features/public_features/functions/secure_storage.dart';

import '../../../const/connection.dart';

class FavoriteApiServices{
  final Dio _dio = Dio();
  // fetch api
  Future<Response> AddToFavoriteApi(String id)async{
    final token = await SecureStorageClass().getUserToken();
    final Response response = await _dio.get('$apiUrl/add-favorite/$id/$token');
    return response;
  }
}