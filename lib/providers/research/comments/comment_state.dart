import 'package:research_mantra_official/data/models/research/get_reserach_comments.dart';

class CommentState {
  final dynamic error;
  final bool isLoading;
  final  List<ResearchMessage>? researchMessage;
  final String ?message;

  CommentState({
    required this.isLoading,
    this.error,
    this.researchMessage,
    this.message
  });

  factory CommentState.initial() => CommentState(
        isLoading: false,
        researchMessage: null,
      );
  factory CommentState.loading() => CommentState(
        isLoading: true,
      );

  factory CommentState.loaded({List<ResearchMessage>? researchMessage,String ?message}) =>
      CommentState(
        isLoading: false,
        researchMessage: researchMessage,
        message: message
      );
  factory CommentState.error(dynamic error) => CommentState(
        isLoading: false,
        error: error,
        researchMessage: null,
      );
}
