import 'package:dio/dio.dart';
import 'package:prokalaproject/const/connection.dart';

class HomeApiServices{
  final Dio _dio = Dio();
  Future<Response>callHomeApi()async{
    _dio.options.connectTimeout = Duration(seconds: 25);
    final Response response = await _dio.get('$apiUrl/index');
    return response;
  }
}