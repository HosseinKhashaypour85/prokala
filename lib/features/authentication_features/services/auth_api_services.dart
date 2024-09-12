import 'package:dio/dio.dart';

import '../../../const/connection.dart';

class AuthApiService {
  final Dio _dio = Dio();

  Future<Response> CallAuthApi(String phoneNumber) async {
    final Response response = await _dio.post(
      '$apiUrl/login',
      queryParameters: {
        'mobile' : phoneNumber,
      },
    );
    return response;
  }
}
