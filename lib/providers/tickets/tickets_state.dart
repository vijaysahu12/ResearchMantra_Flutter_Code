import 'package:research_mantra_official/data/models/tickets/ticket_response_model.dart';

class TicketsState {
  final List<TicketResponseModel> ticketResponseModel;
  final bool isLoading;
  final dynamic error;

  TicketsState({
    required this.ticketResponseModel,
    required this.error,
    required this.isLoading,
  });

  // Factory constructor to create initial state
  factory TicketsState.initial() => TicketsState(
        ticketResponseModel: [],
        error: null,
        isLoading: false,
      );

  // Factory constructor to create loading state
  factory TicketsState.loading(List<TicketResponseModel> ticketResponseModel) =>
      TicketsState(
        ticketResponseModel: [],
        error: null,
        isLoading: true,
      );

  // Factory constructor to create success state
  factory TicketsState.success(List<TicketResponseModel> ticketResponseModel) =>
      TicketsState(
        ticketResponseModel: ticketResponseModel,
        error: null,
        isLoading: false,
      );

  // Factory constructor to create error state
  factory TicketsState.error(dynamic error) => TicketsState(
        ticketResponseModel: [],
        error: error,
        isLoading: false,
      );
}
