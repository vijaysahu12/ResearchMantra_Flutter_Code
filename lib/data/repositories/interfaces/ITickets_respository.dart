import 'dart:io';

import 'package:research_mantra_official/data/models/common_api_response.dart';

import 'package:research_mantra_official/data/models/tickets/message_response_model.dart';
import 'package:research_mantra_official/data/models/tickets/ticket_response_model.dart';

abstract class ITicketRespository {
  Future<List<TicketResponseModel>> getAllTickets(String mobileUserPublicKey);
  Future<CommonHelperResponseModel> manageTicket(String mobileUserPublicKey,
      String description, String subject, String ticketType, String priority,     List<File>? image,
      List<String> aspectRatio);
  Future<List<Messages>> getMessages(int id);

//Get Support Mobile
  Future<String> getSupportMobileDetails();

  Future<Messages> addMessages(
      {required int ticketId,
      required String comment,
      required String mobileUserPublicKey,
      
            List<File>? image,
      List<String>? aspectRatio
      });
}
