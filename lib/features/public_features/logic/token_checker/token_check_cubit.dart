import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:prokalaproject/features/public_features/functions/secure_storage.dart';

part 'token_check_state.dart';

class TokenCheckCubit extends Cubit<TokenCheckState> {
  TokenCheckCubit() : super(TokenCheckInitial());

  tokenChecker()async{
    final status = await SecureStorageClass().getUserToken();
   if(status !=null){
     emit(TokenIsLoged());
     print('true');
   } else{
     emit(TokenIsNotLoged());
     print('false');
   }

  }
}
