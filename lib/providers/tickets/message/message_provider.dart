import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/tickets/message_response_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ITickets_respository.dart';
import 'package:research_mantra_official/providers/tickets/message/message_state.dart';
import 'package:research_mantra_official/main.dart';

class MessageStateProvider extends StateNotifier<MessageState> {
  MessageStateProvider(this._iTicketRespository)
      : super(MessageState.initial());
  final ITicketRespository _iTicketRespository;

//get Method to get all ticket Messages
  Future<void> getAllMessagge(int id) async {
    try {
      state = MessageState.loading([]);
      final List<Messages> getTickets =
          await _iTicketRespository.getMessages(id);
      state = MessageState.success(getTickets);
    } catch (e) {
      state = MessageState.error(e.toString());
    }
  }

//Add Ticket Messages
  Future<void> addMessagge(int ticketId, String comment,
      String mobileUserPublicKey, List<Messages> messages  ,       List<File>? image,
      List<String>? aspectRatio) async {
    try {
      state = MessageState.addCommentloading(state.messages);
      List<Messages> messageData = [];
  


    
      final Messages singleMessage = await _iTicketRespository.addMessages(
          ticketId: ticketId,
          comment: comment,
          mobileUserPublicKey: mobileUserPublicKey,
          image: image,
          aspectRatio: aspectRatio
          
          
          
          );

          print("${singleMessage.images} ${singleMessage.content} ---message");

      messageData = [singleMessage, ...messages];

      state = MessageState.success(messageData);
    } catch (e) {
      state = MessageState.error(e.toString());
    }
  }
}

final getAllMessageStateProvider =
    StateNotifierProvider<MessageStateProvider, MessageState>((ref) {
  final ITicketRespository getTicketRepository = getIt<ITicketRespository>();
  return MessageStateProvider(getTicketRepository);
});
