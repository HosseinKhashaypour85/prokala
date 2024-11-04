import 'package:dio/dio.dart';
import 'package:prokalaproject/features/search_features/services/search_api_services.dart';

import '../model/search_model.dart';

class SearchRepositoryServices{
  final SearchApiServices _apiServices = SearchApiServices();
  Future<SearchModel>callSearchApi(String search)async{
    final Response response = await _apiServices.callSearchApi(search);
    final SearchModel searchModel = SearchModel.fromJson(response.data);
    return searchModel;
  }
}