part of 'comment_bloc.dart';

@immutable
abstract class CommentState {}

class CommentInitial extends CommentState {}

class CommentLoadingState extends CommentState {

}

class CommentCompletedState extends CommentState {
  final CommentModel commentModel;
  CommentCompletedState(this.commentModel);
}

class CommentErrorState extends CommentState {
  final ErrorMessageClass error;
  CommentErrorState({ required this.error});
}


//add comment
class AddCommentLoadingState extends CommentState{

}
class AddCommentErrorState extends CommentState{
  final ErrorMessageClass error;
  AddCommentErrorState({required this.error});
}
class AddCommentCompletedState extends CommentState{
  final String msg;
  AddCommentCompletedState(this.msg);
}