import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prokalaproject/const/responsive.dart';
import 'package:prokalaproject/const/shape/media_query.dart';
import 'package:prokalaproject/const/theme/colors.dart';
import 'package:prokalaproject/features/cart_features/logic/cart_bloc.dart';
import 'package:prokalaproject/features/comments_features/logic/bloc/comment_bloc.dart';
import 'package:prokalaproject/features/comments_features/services/comment_repository.dart';
import 'package:prokalaproject/features/comments_features/widget/text_form_field_multi_line.dart';
import 'package:prokalaproject/features/public_features/widget/snack_bar.dart';

class AddCommentScreen extends StatefulWidget {
  const AddCommentScreen({super.key});

  static const String screenId = '/add_comment_screen';

  @override
  State<AddCommentScreen> createState() => _AddCommentScreenState();
}

class _AddCommentScreenState extends State<AddCommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
      ),
      body: Form(
        key: _key,
        child: BlocProvider(
          create: (context) => CommentBloc(CommentRepository()),
          child: BlocConsumer<CommentBloc, CommentState>(
            builder: (context, state) {
              if (state is AddCommentLoadingState) {
                return Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: getAllWidth(context),
                      child: Text(
                        'ثبت دیدگاه',
                        style: TextStyle(
                          fontFamily: 'sahelbold',
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.sp,
                    ),
                    TextFormFieldMultiLine(
                      minLine: 4,
                      maxLine: 8,
                      labelText: 'دیدگاه',
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.multiline,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      controller: _commentController,
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(
                          getAllWidth(context),
                          Responsive.isTablet(context) ? 60 : 45,
                        ),
                      ),
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          BlocProvider.of<CommentBloc>(context).add(
                            AddCommentEvent(
                                pId: arguments['product_id'].toString(),
                                comment: _commentController.text),
                          );
                        }
                      },
                      child: const Text(
                        'ثبت دیدگاه',
                        style: TextStyle(
                          fontFamily: 'sahelbold',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getWidth(context, 0.1),
                    ),
                  ],
                ),
              );
            },
            listener: (context, state) {
              if (state is AddCommentCompletedState) {
                getSnackBarWidget(context, state.msg, Colors.green);
                Navigator.pop(context);
              }
              if (state is AddCommentErrorState) {
                getSnackBarWidget(context, state.error.errorMsg!, Colors.red);
              }
            },
          ),
        ),
      ),
    );
  }
}
