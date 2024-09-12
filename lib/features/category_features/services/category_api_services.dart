import 'package:dio/dio.dart';
import 'package:prokalaproject/const/connection.dart';

class CategoryApiServices{
  final Dio _dio = Dio();
  // fetch category Api;
  Future<Response>CallCateogryApi() async{
    Response response = await _dio.get(apiUrl+ '/get-menu-category');
    return response;
}
}