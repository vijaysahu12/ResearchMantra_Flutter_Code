import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/research/get_reserach_comments.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IResearch_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/research/comments/comment_state.dart';

class CommmmentPriovider extends StateNotifier<CommentState> {
  CommmmentPriovider(this._researchRepository) : super(CommentState.initial());

  final IResearchRepository _researchRepository;

  Future<void> getReserachMessagesData(num id) async {
    try {
      state = CommentState.loading();

      final researchMessages =
          await _researchRepository.getReserachMessages(id);

      state = CommentState.loaded(researchMessage: researchMessages);
    } catch (e) {
      state = CommentState.error(e.toString());
    }
  }

  Future<void> postReserachMessages(Map<String, dynamic> body,
      List<ResearchMessage>? researchMessage, String userName) async {
    try {
      state = CommentState.loading();

      final message = await _researchRepository.postReserachMessages(body);

      List<ResearchMessage> researchMessageData = [];
      ResearchMessage? singlemessage;
      if (body["secondaryKey"] == null) {
        ResearchMessage addValue = ResearchMessage(
            id: message["messageId"],
            publicKey: body["loggedInUser"],
            message: body["primaryKey"],
            modifiedBy: userName,
            modifiedOn: DateTime.now().toString());

        print(
            "${addValue.id}${addValue.modifiedOn}  ${addValue.publicKey}  ---value");
        researchMessageData = [addValue, ...researchMessage ?? []];
        // researchMessageData.add(addValue);
      } else if (body["secondaryKey"] == "edit") {
        int length = researchMessage?.length ?? 0;
        researchMessageData = [...researchMessage ?? []];
        for (int i = 0; i < length; i++) {
          if (researchMessage?[i].id == body["id"]) {
            singlemessage = ResearchMessage(
                id: researchMessage?[i].id,
                publicKey: researchMessage?[i].publicKey,
                message: body["primaryKey"],
                modifiedBy: researchMessage?[i].modifiedBy,
                modifiedOn: DateTime.now().toString());

            researchMessageData.removeAt(i);
            break;
          }
        }

        if (singlemessage != null) {
          researchMessageData = [singlemessage, ...researchMessageData];
        }
      } else if (body["secondaryKey"] == "delete") {
        int length = researchMessage?.length ?? 0;
        researchMessageData = [...researchMessage ?? []];
        for (int i = 0; i < length; i++) {
          if (researchMessage?[i].id == body["id"]) {
            researchMessageData.removeAt(i);
          }
        }
      }

      state = CommentState.loaded(
          researchMessage: researchMessageData, message: message["message"]);
    } catch (e) {
      state = CommentState.error(e.toString());
    }
  }
}

final commentsDetailsProvider =
    StateNotifierProvider<CommmmentPriovider, CommentState>(((ref) {
  final IResearchRepository companiesResearchRepository =
      getIt<IResearchRepository>();
  return CommmmentPriovider(companiesResearchRepository);
}));
