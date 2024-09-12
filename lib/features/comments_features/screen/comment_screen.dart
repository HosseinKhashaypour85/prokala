import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prokalaproject/const/theme/colors.dart';
import 'package:prokalaproject/features/comments_features/logic/bloc/comment_bloc.dart';
import 'package:prokalaproject/features/comments_features/screen/add_comment_screen.dart';
import 'package:prokalaproject/features/comments_features/services/comment_repository.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key});

  static const String screenId = '/comment_screen';

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AddCommentScreen.screenId , arguments: {'product_id' : arguments['product_id']} );
        },
        label: Row(
          children: [
            const Text(
              'افزودن نظر',
              style: TextStyle(fontFamily: 'sahelbold'),
            ),
            SizedBox(
              width: 5.sp,
            ),
            const Icon(Icons.add_comment),
          ],
        ),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => CommentBloc(
            CommentRepository(),
          )..add(CallShowCommentsEvent(arguments['product_id'].toString())),
          child: BlocBuilder<CommentBloc, CommentState>(
            builder: (context, state) {
              if (state is CommentLoadingState) {
                return const Center(
                  // Centered the CircularProgressIndicator
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }
              if (state is CommentCompletedState) {
                return ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: state.commentModel.allComments!.length,
                  itemBuilder: (context, index) {
                    final helper = state.commentModel.allComments![index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              helper.fullname!,
                              style: TextStyle(
                                fontFamily: 'sahelbold',
                                fontSize: 13.sp,
                              ),
                            ),
                            Text(
                              helper.comment!,
                              style: TextStyle(
                                fontFamily: 'sahelbold',
                                fontSize: 12.sp,
                              ),
                            ),
                            Text(
                              helper.date!,
                              style: TextStyle(
                                  fontFamily: 'sahelbold',
                                  fontSize: 11.sp,
                                  color: primary2Color),
                            ),
                            helper.commentReplay == null
                                ? const Text(
                                    'پاسخی وجود ندارد',
                                    style: TextStyle(
                                      fontFamily: 'sahelbold',
                                    ),
                                  )
                                : RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'پاسخ ادمین',
                                          style: TextStyle(
                                            fontFamily: 'sahelbold',
                                            fontSize: 14.sp,
                                            color: primaryColor,
                                          ),
                                        ),
                                        TextSpan(
                                          text: helper.commentReplay!,
                                          style: TextStyle(
                                            fontFamily: 'sahelbold',
                                            fontSize: 14.sp,
                                            color: primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              if (state is CommentErrorState) {
                return Text(
                  state.error.errorMsg!.toString(),
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'sahelbold',
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
