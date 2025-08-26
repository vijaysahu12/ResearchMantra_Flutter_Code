
import 'package:research_mantra_official/data/models/tickets/message_response_model.dart';


class MessageState {
  final List<Messages> messages;
  final bool isLoading;
  final dynamic error;
  final bool  isAdding;

  MessageState({
    required this.messages,
    required this.error,
    required this.isLoading,
    required this.isAdding,
  });

  // Factory constructor to create initial state
  factory MessageState.initial() => MessageState(
        messages: [],
        error: null,
        isLoading: false,
        isAdding: false,
      );

  // Factory constructor to create loading state
  factory MessageState.loading(List<Messages> messages) =>
      MessageState(
        messages: [],
        error: null,
        isLoading: true,
        isAdding: false,
      );

  // Factory constructor to create success state
  factory MessageState.success(List<Messages> messages) =>
      MessageState(
        messages: messages,
        error: null,
        isLoading: false,
      isAdding: false,
      );
  factory MessageState.addCommentloading(List<Messages> messages) =>
      MessageState(
        messages: messages,
        error: null,
        isLoading: false,
        isAdding: true,
      
      );

  // Factory constructor to create error state
  factory MessageState.error(dynamic error) => MessageState(
        messages: [],
        error: error,
        isLoading: false,
        isAdding: false,
      );
}
