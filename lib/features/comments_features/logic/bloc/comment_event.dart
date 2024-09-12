part of 'comment_bloc.dart';

@immutable
abstract class CommentEvent {}

class CallShowCommentsEvent extends CommentEvent {
  final String productId;
  CallShowCommentsEvent(this.productId);
}


class AddCommentEvent extends CommentEvent{
  final String pId;
  final String comment;
  AddCommentEvent({required this.pId, required this.comment});
}