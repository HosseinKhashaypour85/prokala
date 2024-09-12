import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class SecureStorageClass{

  Future<String?> getUserToken()async{
    final token = await const FlutterSecureStorage().read(key: 'token');
    return token;
  }


  Future<void> SaveUserToken(token)async{
    await const FlutterSecureStorage().write(key: 'token', value: token);
  }

  Future<void> DeleteUserToken()async{
    const FlutterSecureStorage().delete(key: 'token');
  }
}