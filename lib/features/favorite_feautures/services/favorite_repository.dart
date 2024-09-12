import 'package:dio/dio.dart';
import 'package:prokalaproject/features/favorite_feautures/services/favorite_api_services.dart';

class FavoriteRepository{
  final FavoriteApiServices _apiServices = FavoriteApiServices();

  Future<bool>addToFavorite(String id)async{
    final Response response = await _apiServices.AddToFavoriteApi(id);
    return response.data['boolean'];
  }
}