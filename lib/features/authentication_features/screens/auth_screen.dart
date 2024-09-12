import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prokalaproject/const/responsive.dart';
import 'package:prokalaproject/const/shape/media_query.dart';
import 'package:prokalaproject/features/authentication_features/logic/auth_bloc.dart';
import 'package:prokalaproject/features/authentication_features/services/auth_repository.dart';
import 'package:prokalaproject/features/authentication_features/widget/textfornfield_widget.dart';
import 'package:prokalaproject/features/public_features/functions/secure_storage.dart';
import 'package:prokalaproject/features/public_features/logic/token_checker/token_check_cubit.dart';
import 'package:prokalaproject/features/public_features/screens/bottom_nav_bar_screen.dart';
import 'package:prokalaproject/features/public_features/widget/snack_bar.dart';

import '../../../const/theme/colors.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  static const String ScreenId = '/auth_screen';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _PhoneEditingController = TextEditingController();
  GlobalKey<FormState> _FormState = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _PhoneEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: WaveClipperOne(),
          child: Container(
            height: 200.sp,
            color: primaryColor,
          ),
        ),
        BlocProvider(
          create: (context) => AuthBloc(AuthRepository()),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthCompletedState) {
                SecureStorageClass().SaveUserToken(state.token);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  BottomNavBarScreen.screenId,
                  (route) => false,
                );
                return getSnackBarWidget(
                  context,
                  'با موفقیت وارد شدید',
                  Colors.green,
                );
              }
              if (state is AuthErrorState) {
                return getSnackBarWidget(
                  context,
                  state.errorMessageClass.errorMsg!,
                  Colors.red,
                );
              }
            },
            builder: (context, state) {
              if (state is AuthLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }
              return Center(
                child: Form(
                  key: _FormState,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo2.png',
                        width: getWidth(context, 0.38),
                      ),
                      Text(
                        'برای احراز هویت شماره خود را وارد کنید',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'sahelbold',
                            fontSize: 12.sp),
                      ),
                      SizedBox(
                        height: 10.sp,
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.sp),
                        child: TextFormFieldMobileWidget(
                          labelText: 'شماره موبایل',
                          icon: const Icon(Icons.mobile_friendly_outlined),
                          textInputAction: TextInputAction.done,
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          controller: _PhoneEditingController,
                        ),
                      ),
                      SizedBox(
                        height: 10.sp,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(
                            getWidth(context, 0.6),
                            Responsive.isTablet(context) ? 60 : 45,
                          ),
                        ),
                        onPressed: () {
                          if (_FormState.currentState!.validate()) {
                            BlocProvider.of<AuthBloc>(context).add(
                              CallAuthEvent(_PhoneEditingController.text),
                            );
                          }
                        },
                        child: const Text(
                          'احراز هویت',
                          style: TextStyle(
                            fontFamily: 'sahelbold',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
