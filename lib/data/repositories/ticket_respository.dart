
import 'dart:io';

import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/data/models/common_api_response.dart';
import 'package:research_mantra_official/data/models/tickets/message_response_model.dart';

import 'package:research_mantra_official/data/models/tickets/ticket_response_model.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ITickets_respository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

//  TicketRepository implementation
class TicketRepository implements ITicketRespository {
  final HttpClient _httpClient = getIt<HttpClient>();

  // Get list of Tickets

  @override
  Future<List<TicketResponseModel>> getAllTickets(
      String mobileUserPublicKey) async {
    try {
      final response = await _httpClient
          .get("$getAllTicketsApi?mobileUserKey=$mobileUserPublicKey");
      if (response.statusCode == 200) {
        final List<dynamic> myBucketData = response.data;
        final List<TicketResponseModel> myBucketListData = myBucketData
            .map((data) => TicketResponseModel.fromJson(data))
            .toList();
        return myBucketListData;
      } else {
        // If the status code is not 200, throw an exception
        throw Exception('Failed to load tickets: ${response.statusCode}');
      }
    } catch (error) {
      print(error);
      throw Exception('Failed to load tickets: $error');
    }
  }

//Manage Ticket
  @override
  Future<CommonHelperResponseModel> manageTicket(
      String mobileUserPublicKey,
      String description,
      String subject,
      String ticketType,
      String priority,
      List<File>? image,
      List<String> aspectRatio) async {
    try {
      final Map<String, String> body = {
        "description": description,
        "createdBy": mobileUserPublicKey,
        "ticketType": ticketType,
        "priority": priority,
        "status": "O",
        "subject": subject,
      };

      final response = await _httpClient.postWithMultiPartWithMultipleImages(
          getAllTicketsApi, body, image, "Images", aspectRatio);
      final result = CommonHelperResponseModel.fromJson(response);
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<Messages>> getMessages(int id) async {
    try {
      final response =
          await _httpClient.post("$getTicketCommentsDetails?id=$id", null);

      if (response.statusCode == 200) {
        final List<dynamic> myBucketData = response.data["messages"];

        final List<Messages> messages =
            myBucketData.map((data) => Messages.fromJson(data)).toList();
        return messages;
      } else {
        // If the status code is not 200, throw an exception
        throw Exception('Failed to load tickets: ${response.statusCode}');
      }
    } catch (error) {
      print(error);
      throw Exception('Failed to load tickets: $error');
    }
  }

  @override
  Future<Messages> addMessages(
      {required int ticketId,
      required String comment,
      required String mobileUserPublicKey,
      List<File>? image,
      List<String>? aspectRatio}) async {
    try {
      final response = await _httpClient.postWithMultiPartWithMultipleImages(
          addTicketComments,
          {
            "ticketId": ticketId.toString(),
            "comment": comment,
            "mobileUserKey": mobileUserPublicKey,
          },
          image,
          "Images",
          aspectRatio ?? []);

      if (response.statusCode == 200) {
        final singleMessage = response.data;
        Messages singleMessageData = Messages.fromJson(singleMessage);

        ToastUtils.showToast(response.message, '');

        return singleMessageData;
      } else {
        // If the status code is not 200, throw an exception
        throw Exception('Failed to load tickets: ${response.statusCode}');
      }
    } catch (error) {
      print(error);
      throw Exception('Failed to load tickets: $error');
    }
  }

  @override
  Future<String> getSupportMobileDetails() async {
    try {
      final response = await _httpClient.get(getSupportMobileApi);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }
}
