import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:prokalaproject/features/comments_features/model/comment_model.dart';
import 'package:prokalaproject/features/public_features/error/error_message_class.dart';

import '../../../public_features/error/error_exception.dart';
import '../../services/comment_repository.dart';

part 'comment_event.dart';

part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository commentRepository;

  CommentBloc(this.commentRepository) : super(CommentInitial()) {
    on<CallShowCommentsEvent>(
      (event, emit) async {
        emit(CommentLoadingState());
        try {
          final CommentModel commentModel =
              await commentRepository.callShowComment(event.productId);
          emit(CommentCompletedState(commentModel));
        } on DioException catch (e) {
          emit(CommentErrorState(
              error:
                  ErrorMessageClass(errorMsg: ErrorExceptions().fromError(e))));
        }
      },
    );
    on<AddCommentEvent>(
      (event, emit) async {
       emit(AddCommentLoadingState());
       try{
         final String message = await commentRepository.addCommentApi(event.comment, event.pId);
         emit(AddCommentCompletedState(message));
       }
           on DioException catch(e){
             emit(AddCommentErrorState(
                 error:
                 ErrorMessageClass(errorMsg: ErrorExceptions().fromError(e))));
           }
      },
    );
  }
}
