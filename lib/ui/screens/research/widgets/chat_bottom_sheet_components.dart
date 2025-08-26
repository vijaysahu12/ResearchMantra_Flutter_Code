import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/constants/storage.dart';
import 'package:research_mantra_official/data/models/research/get_reserach_comments.dart';
import 'package:research_mantra_official/providers/research/comments/comment_provider.dart';
import 'package:research_mantra_official/providers/research/reports/research_provider.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/words/negative_words.dart';
import 'package:research_mantra_official/ui/screens/research/widgets/messge_tile.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:research_mantra_official/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

class ChatBottomSheetComponents extends ConsumerStatefulWidget {
  final num id;
  const ChatBottomSheetComponents({
    super.key,
    required this.id,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChatBottomSheetComponentsState();
}

class _ChatBottomSheetComponentsState
    extends ConsumerState<ChatBottomSheetComponents> {
  late final TextEditingController _controller;
  final UserSecureStorageService _commonDetails = UserSecureStorageService();
  String publicKey = "";
  String userName = "";
  bool hasBadWords = true;
  int? messageId;
  bool enabled = true;
  late final FocusNode _textFieldFocusNode;

  void _sendMessage(
      {required Map<String, dynamic> message,
      List<ResearchMessage>? researchMessage,
      String? updateCommentCount}) {
    ref
        .read(commentsDetailsProvider.notifier)
        .postReserachMessages(message, researchMessage, userName)
        .then((value) => ref
            .read(researchDetailsProvider.notifier)
            .updateCommentCount(updateCommentCount ?? ""));

    _controller.clear();
    setState(() {
      hasBadWords = true;
    });
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    _textFieldFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      publicKey = await _commonDetails.getPublicKey();

      Map<String, dynamic> value = await _commonDetails.getUserDetails();
      userName = value['fullName'];

      ref
          .read(commentsDetailsProvider.notifier)
          .getReserachMessagesData(widget.id);
    });
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageWatch = ref.watch(commentsDetailsProvider);
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding:
            MediaQuery.of(context).viewInsets, // Adjust padding for keyboard
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  comments,
                  style: textH4,
                ),
              ),
              const Divider(),
              messageWatch.error != null ||
                      messageWatch.researchMessage?.length == 0
                  ? Center(
                      child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildForNoComments(theme),
                    ))
                  : Container(
                      padding: const EdgeInsets.all(10),
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: messageWatch.isLoading
                          ? Shimmer.fromColors(
                              enabled: messageWatch.isLoading,
                              baseColor: Colors.grey.withOpacity(0.3),
                              highlightColor: Colors.grey.withOpacity(0.1),
                              child: ListView.builder(
                                itemCount:
                                    messageWatch.researchMessage?.length ?? 10,
                                itemBuilder: (BuildContext context, int index) {
                                  return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 250),
                                      child: SlideAnimation(
                                          verticalOffset: 100.0,
                                          child: FadeInAnimation(
                                              child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Container(
                                              width: double.infinity,
                                              height: 80,
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: theme.shadowColor),
                                            ),
                                          ))));
                                },
                              ),
                            )
                          : ListView.builder(
                              itemCount:
                                  messageWatch.researchMessage?.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Slidable(
                                      key: ValueKey(index),
                                      enabled: Utils.isWithin30MinutesDifference(
                                                  dateTimeString: messageWatch
                                                          .researchMessage?[
                                                              index]
                                                          .modifiedOn ??
                                                      DateTime.now().toString(),
                                                  publicKeyData: messageWatch
                                                          .researchMessage?[
                                                              index]
                                                          .publicKey ??
                                                      "",
                                                  publicKey: publicKey) ==
                                              true
                                          ? true
                                          : false,
                                      endActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            onPressed: (context) {
                                              _controller.text = messageWatch
                                                      .researchMessage?[index]
                                                      .message ??
                                                  noMessage;
                                              messageId = messageWatch
                                                  .researchMessage?[index].id;
                                              _textFieldFocusNode
                                                  .requestFocus();
                                            },
                                            backgroundColor:
                                                const Color(0xFF7BC043),
                                            foregroundColor: Colors.white,
                                            icon: Icons.edit,
                                            label: edit,
                                          ),
                                          SlidableAction(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            onPressed: (context) {
                                              _sendMessage(
                                                  updateCommentCount: "del",
                                                  message: {
                                                    id: messageWatch
                                                        .researchMessage?[index]
                                                        .id,
                                                    primaryKey:
                                                        _controller.text.trim(),
                                                    loggedInUser: publicKey,
                                                    secondaryKey:
                                                        deleteSmallCase
                                                  },
                                                  researchMessage: messageWatch
                                                      .researchMessage);
                                            },
                                            backgroundColor:
                                                const Color(0xFFFE4A49),
                                            foregroundColor: Colors.white,
                                            icon: Icons.delete,
                                            label: delete,
                                          ),
                                        ],
                                      ),
                                      child: MessageTile(
                                        message: messageWatch
                                                .researchMessage?[index]
                                                .message ??
                                            noMessage,
                                        time: Utils.formatDateTime(
                                            dateTimeString: messageWatch
                                                    .researchMessage?[index]
                                                    .modifiedOn ??
                                                DateTime.now().toString(),
                                            format: ddmmtt),
                                        senderName: messageWatch
                                                .researchMessage?[index]
                                                .modifiedBy ??
                                            "",
                                      )),
                                );
                              },
                            ),
                    ),
              _buildAddCommentTextField(
                  researchMessage: messageWatch.researchMessage),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddCommentTextField({List<ResearchMessage>? researchMessage}) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.focusColor,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  focusNode: _textFieldFocusNode,
                  keyboardType: TextInputType.text,
                  maxLength: 200,
                  minLines: 1,
                  maxLines: 4,
                  // autofocus: !widget.isLoading,
                  controller: _controller,
                  onChanged: (text) {
                    setState(() {
                      hasBadWords = _controller.text.trim().isEmpty
                          ? true
                          : containBadwords(_controller.text.trim());
                    });
                  },
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: addAComment,
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: theme.primaryColorDark,
                      fontWeight: FontWeight.w500,
                    ),
                    border: InputBorder.none,
                    // suffixIcon:
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: (_controller.text.length > 1 && !hasBadWords)
                ? IconButton(
                    onPressed: () {
                      if (messageId != null) {
                        _sendMessage(message: {
                          id: messageId,
                          primaryKey: _controller.text.trim(),
                          loggedInUser: publicKey,
                          secondaryKey: editSmallCase
                        }, researchMessage: researchMessage);
                      } else {
                        _sendMessage(
                            updateCommentCount: "add",
                            message: {
                              id: widget.id,
                              primaryKey: _controller.text.trim(),
                              loggedInUser: publicKey
                            },
                            researchMessage: researchMessage);
                      }
                      messageId = null;
                    },
                    icon: Icon(
                      Icons.send,
                      color: theme.primaryColorDark,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildForNoComments(theme) {
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            noCommentTextButton,
            style: TextStyle(
                fontSize: 20,
                color: theme.primaryColorDark,
                fontFamily: fontFamily,
                fontWeight: FontWeight.w600),
          ),
          Text(
            noCommentScreenBottomText,
            style: TextStyle(
                color: theme.primaryColorDark.withOpacity(0.6),
                fontFamily: fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
