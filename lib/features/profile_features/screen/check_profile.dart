import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prokalaproject/features/authentication_features/screens/auth_screen.dart';
import 'package:prokalaproject/features/profile_features/screen/profile_screen.dart';
import 'package:prokalaproject/features/public_features/logic/token_checker/token_check_cubit.dart';

class CheckProfileScreen extends StatelessWidget {
  const CheckProfileScreen({super.key});

  static const String screenId = '/check_profile';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TokenCheckCubit, TokenCheckState>(
      builder: (context, state) {
        if(state is TokenIsLoged){
          return const ProfileScreen();
        } else{
          return const AuthScreen();
        }
      },
    );
  }
}
