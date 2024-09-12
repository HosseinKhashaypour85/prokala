import 'package:dio/dio.dart';
import 'package:prokalaproject/const/connection.dart';
import 'package:prokalaproject/features/public_features/functions/secure_storage.dart';

class CommentApiServices {
  final Dio _dio = Dio();

  // show comment api
  // api code : http://programmingshow.ir/api/api/comment/product/8
  Future<Response> callShowComment(String productId) async {
    final Response response =
        await _dio.get('$apiUrl/comment/product/$productId');
    return response;
  }

//   add comment api
  Future<Response> addCommentApi(String comment , String pId) async {
    final token = await SecureStorageClass().getUserToken();
    final Response response = await _dio.post(
      '$apiUrl/save-comment',
      queryParameters: {
        'token' : token,
        'comment' : comment,
        'type' : 'product',
        'pId' : pId,
      },
    );
    return response;
  }
}
