import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/tickets/ticket_response_model.dart';

import 'package:research_mantra_official/data/repositories/interfaces/ITickets_respository.dart';

import 'package:research_mantra_official/providers/tickets/tickets_state.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

class TicketsStateProvider extends StateNotifier<TicketsState> {
  TicketsStateProvider(this._iTicketRespository)
      : super(TicketsState.initial());
  final ITicketRespository _iTicketRespository;

//get Method to get all tickets
  Future<void> getAllTicketList(String mobileUserPublicKey) async {
    try {
     state = TicketsState.loading([]);
      final List<TicketResponseModel> getTickets =
          await _iTicketRespository.getAllTickets(mobileUserPublicKey);
      state = TicketsState.success(getTickets);
    } catch (e) {
      state = TicketsState.error(e.toString());
    }
  }

//manage ticket to add a new ticket
  Future<void> manageTicketList(String mobileUserPublicKey, String description,
      String subject, String priorityType, String ticketType     ,  List<File>? image,
  List<String> aspectRatio,) async {
    try {
      state = TicketsState.success(state.ticketResponseModel);

      final response = await _iTicketRespository.manageTicket(
          mobileUserPublicKey, description, subject, ticketType, priorityType ,image,aspectRatio);
      if (response.status) {
        print("${response.data} ---response data");
        final newData = TicketResponseModel(
            id: response.data["ticketId"],
            description: description,
            ticketType: ticketType,
            priority: priorityType,
            subject: subject,
            status: "O",
            );
        final List<TicketResponseModel> updatedTickets =
            List.from(state.ticketResponseModel ?? []);
        updatedTickets.insert(0, newData);

        state = TicketsState.success(updatedTickets);
        ToastUtils.showToast("Support request raised successfully", "error");
      } else {
        ToastUtils.showToast(response.message, "error");
      }
    } catch (e) {
      state = TicketsState.error(e.toString());
    }
  }

  //get Method to get all tickets
  Future<void> getUpdateTicket(int ticketId) async {
    try {
      List<TicketResponseModel> ticketResponseModel = List.from(state.ticketResponseModel);
        int index = ticketResponseModel.indexWhere((element) => element.id == ticketId);

        if(index !=-1){

  TicketResponseModel ticketResponseModelSingle = TicketResponseModel(
          ticketType: ticketResponseModel[index].ticketType,
          priority: ticketResponseModel[index].priority,
          subject: ticketResponseModel[index].subject,
          description: ticketResponseModel[index].description,
          status: "C");

      ticketResponseModel[index] = ticketResponseModelSingle;

        }

    

      state = TicketsState.success(ticketResponseModel);
    } catch (e) {
      state = TicketsState.error(e.toString());
    }
  }
}

final getAllTicketsStateProvider =
    StateNotifierProvider<TicketsStateProvider, TicketsState>((ref) {
  final ITicketRespository getTicketRepository = getIt<ITicketRespository>();
  return TicketsStateProvider(getTicketRepository);
});
