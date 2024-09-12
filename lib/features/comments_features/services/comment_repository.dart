import 'package:dio/dio.dart';
import 'package:prokalaproject/features/comments_features/model/comment_model.dart';
import 'package:prokalaproject/features/comments_features/services/comment_api_services.dart';

class CommentRepository{
  final CommentApiServices _apiServices = CommentApiServices();

  Future<CommentModel>callShowComment(String productId)async{
    final Response response = await _apiServices.callShowComment(productId);
    final CommentModel commentModel = CommentModel.fromJson(response.data);
    return commentModel;
  }

  Future<String>addCommentApi(String comment , String pId )async{
    final Response response = await _apiServices.addCommentApi(comment, pId);
    return response.data['msg'];
  }
}