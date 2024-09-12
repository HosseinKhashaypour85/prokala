import 'package:dio/dio.dart';
import 'package:prokalaproject/features/authentication_features/services/auth_api_services.dart';

class AuthRepository{
  final AuthApiService _apiService = AuthApiService();

  Future<String?> CallAuthApi(String phoneNumber)async{
    final Response response = await _apiService.CallAuthApi(phoneNumber);
    final String? token = response.data['token'];
    return token;
  }
}