import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prokalaproject/features/authentication_features/screens/auth_screen.dart';
import 'package:prokalaproject/features/cart_features/screen/cart_screen.dart';
import 'package:prokalaproject/features/public_features/logic/token_checker/token_check_cubit.dart';

class CheckCart extends StatelessWidget {
  const CheckCart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TokenCheckCubit(),
      child: BlocBuilder<TokenCheckCubit, TokenCheckState>(
        builder: (context, state) {
          if (state is TokenIsLoged) {
            return const AuthScreen();
          }
          else{
            return const CartScreen();
          }
        },
      ),
    );
  }
}
