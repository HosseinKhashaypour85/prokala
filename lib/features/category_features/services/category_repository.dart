import 'package:dio/dio.dart';
import 'package:prokalaproject/features/category_features/services/category_api_services.dart';

import '../model/category_model.dart';

class CategoryRepository{
  final CategoryApiServices _apiServices = CategoryApiServices();

  Future<CategoryModel>fetchCategoryModel() async{
    Response response = await _apiServices.CallCateogryApi();
    final CategoryModel categoryModel = CategoryModel.fromJson(response.data);
    return categoryModel;
  }
}