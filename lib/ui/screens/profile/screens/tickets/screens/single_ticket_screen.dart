import 'dart:async';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/constants/storage.dart';
import 'package:research_mantra_official/data/models/tickets/images_response_model.dart';
import 'package:research_mantra_official/data/models/tickets/message_response_model.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/tickets/message/message_provider.dart';
import 'package:research_mantra_official/providers/tickets/message/message_state.dart';
import 'package:research_mantra_official/services/check_connectivity.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/cacher_network_images/circular_cached_network_image.dart';
import 'package:research_mantra_official/ui/components/common_error/no_connection.dart';
import 'package:research_mantra_official/ui/components/indicator.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/components/words/negative_words.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/tickets/widgets/upload_media.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:research_mantra_official/utils/utils.dart';

class SingleTicketScreen extends ConsumerStatefulWidget {
  final String title;
  final String chatMessgae;
  final String priority;
  final String ticketStatus;
  final int ticketId;
  const SingleTicketScreen({
    super.key,
    required this.title,
    required this.ticketId,
    required this.priority,
    required this.chatMessgae,
    required this.ticketStatus,
  });

  @override
  ConsumerState<SingleTicketScreen> createState() => _SingleTicketScreenState();
}

class _SingleTicketScreenState extends ConsumerState<SingleTicketScreen> {
  late final UserSecureStorageService _commonDetails;
  late final String mobileUserPublicKey;
  late final FocusNode _textFieldFocusNode;
  bool hasBadWords = true;
  int currentIndex = 0;
  int selectedIndex = 0;
  Key carouselKey = UniqueKey();
  @override
  void initState() {
    super.initState();
    _textFieldFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      getMessages();
      _commonDetails = UserSecureStorageService();

      mobileUserPublicKey = await _commonDetails.getPublicKey();
    });
  }

  Future<void> getMessages() async {
    final bool value = await _checkAndFetch();

    if (value) {
      await ref
          .read(getAllMessageStateProvider.notifier)
          .getAllMessagge(widget.ticketId);
    }
  }

  Future<bool> _checkAndFetch() async {
    bool checkConnection =
        await CheckInternetConnection().checkInternetConnection();
    ref
        .read(connectivityProvider.notifier)
        .updateConnectionStatus(checkConnection);

    return checkConnection;
  }

  void _sendMessage(List<Messages> message) async {
    final bool value = await _checkAndFetch();

    if (value) {
      await ref.read(getAllMessageStateProvider.notifier).addMessagge(
          widget.ticketId,
          supportTextEditController.text.trim(),
          mobileUserPublicKey,
          message,
          null,
          null);
      supportTextEditController.clear();
      setState(() {
        hasBadWords = true;
      });
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  void dispose() {
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  final TextEditingController supportTextEditController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool checkConnection = ref.watch(connectivityProvider);
    final getMessageData = ref.watch(getAllMessageStateProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: theme.primaryColor,
        appBar: CommonAppBarWithBackButton(
          appBarText: widget.title,
          handleBackButton: () {
            Navigator.pop(context);
          },
        ),
        body: !checkConnection
            ? NoInternet(handleRefresh: getMessages)
            : getMessageData.isLoading
                ? const CommonLoaderGif()
                : RefreshIndicator(
                    onRefresh: getMessages,
                    child: Column(
                      children: [
                        if (getMessageData.isAdding)
                          const ProgressIndicatorExample(),
                        Expanded(
                            child: getMessageData.messages.isEmpty
                                ? Center(
                                    child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: _buildForNoComments(theme),
                                  ))
                                : _buildForChatText(theme, getMessageData)),
                        if (getMessageData.messages.isNotEmpty)
                          //  getMessageData.messages[0].sender != "user" &&
                          widget.ticketStatus != "C" &&
                                  getMessageData.messages[0].ticketStatus != "C"
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _buildTextField(getMessageData),
                                )
                              : SizedBox(
                                  child: MovingMessages(
                                  isClosed: widget.ticketStatus == "C" ||
                                      getMessageData.messages[0].ticketStatus ==
                                          "C",
                                  color:
                                      Utils.matchPriorityColor(widget.priority),
                                )),
                        if (getMessageData.messages.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _buildTextField(getMessageData),
                          )
                      ],
                    ),
                  ),
      ),
    );
  }

  //widget for chat box
  Widget _buildForChatText(ThemeData theme, MessageState getMessageData) {
    return Align(
      alignment: Alignment.topCenter,
      child: ListView.builder(
          reverse: true,
          shrinkWrap: true,
          padding: const EdgeInsets.all(10),
          itemCount: getMessageData.messages.length,
          itemBuilder: ((context, index) {
            String date = getMessageData.messages[index].timestamp.toString();

            String? newDate = index + 1 < getMessageData.messages.length
                ? getMessageData.messages[index + 1].timestamp.toString()
                : null;

            return Column(
              children: [
                if (newDate?.substring(0, 10) != date.substring(0, 10))
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Utils.formatDateTime(
                          dateTimeString: date, format: ddmmyy),
                      style: textH4.copyWith(fontSize: 13),
                    ),
                  ),
                MessageBubble(
                    image: getMessageData.messages[index].images,
                    time: getMessageData.messages[index].timestamp
                        .toString()
                        .substring(11, 16),
                    sender: "Admin",
                    message: getMessageData.messages[index].content ?? "",
                    isSender: getMessageData.messages[index].sender == "user"
                        ? true
                        : false)
              ],
            );
          })),
    );
  }

  Widget _buildTextField(MessageState messageData) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
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
              padding: const EdgeInsets.symmetric(
                horizontal: 5.0,
              ),
              child: TextFormField(
                minLines: 1,
                maxLines: 4,
                readOnly: messageData.isAdding,
                focusNode: _textFieldFocusNode,
                keyboardType: TextInputType.text,
                maxLength: 260,
                controller: supportTextEditController,
                onChanged: (text) {
                  setState(() {
                    hasBadWords = supportTextEditController.text.trim().isEmpty
                        ? true
                        : containBadwords(
                            supportTextEditController.text.trim());
                  });
                },
                onTap: () {},
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      size: 30,
                      color: theme.primaryColorDark,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UploadMediaScreen(
                              mobileUserPublicKey: mobileUserPublicKey,
                              ticketId: widget.ticketId,
                              supportTextMessage:
                                  supportTextEditController.text.trim(),
                              message: messageData.messages,
                            ),
                          ));
                    },
                  ),
                  counterText: '',
                  hintText: "Write your Issues",
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: theme.primaryColorDark,
                    fontFamily: fontFamily,
                  ),
                  border: InputBorder.none,
                  // suffixIcon:
                ),
              ),
            ),
          ),
        ),
        Container(
            child: hasBadWords
                ? null
                : messageData.isAdding
                    ? null
                    : IconButton(
                        onPressed: () => _sendMessage(messageData.messages),
                        icon: Icon(
                          Icons.send,
                          color: theme.primaryColorDark,
                        ),
                      )),
      ]),
    );
  }
}

class MessageBubble extends StatefulWidget {
  final String message;
  final bool isSender;
  final String time;
  final String sender;
  final List<Images>? image;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isSender,
    required this.time,
    required this.sender,
    this.image,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  int currentIndex = 0;
  int selectedIndex = 0;
  Key carouselKey = UniqueKey();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    int imagesLength = widget.image?.length ?? 0;
    return Align(
      alignment: widget.isSender ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          color: theme.shadowColor,
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(15),
              topRight: const Radius.circular(15),
              bottomLeft: widget.isSender
                  ? const Radius.circular(15)
                  : const Radius.circular(0),
              bottomRight: widget.isSender
                  ? const Radius.circular(0)
                  : const Radius.circular(15)),
        ),
        child: Column(
          crossAxisAlignment: widget.isSender
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Text(
                "${!widget.isSender ? widget.sender : "You"} ${widget.time} ",
                style: TextStyle(
                  color: theme.primaryColorDark,
                  fontSize: 10,
                ),
              ),
            ),
            // Text(widget.image?.last.name.toString() ??"No Added" ),
            if (widget.image != null && widget.image?.length != 0) ...[
              CarouselSlider.builder(
                itemCount: widget.image?.length ?? 0,
                itemBuilder: (context, index, realIndex) {
                  String imageUrl = widget.image?[index].name ?? "";

                  return InkWell(
                    onTap: () {
                      if (imageUrl.isNotEmpty) {
                        Utils.showFullScreenImage(
                            context,
                            NetworkImage(
                                "$getTicketImages?imageName=$imageUrl"),
                            null);
                      }
                    },
                    child: (imageUrl.startsWith('/'))
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(imageUrl),
                              fit: BoxFit.fill,
                            ),
                          )
                        : CircularCachedNetworkLandScapeImages(
                            imageURL: imageUrl,
                            baseUrl: getTicketImages,
                            defaultImagePath: productLandScapeImage,
                            aspectRatio: 1,
                          ),
                  );
                },
                options: CarouselOptions(
                  aspectRatio: 1,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: widget.image!.length > 1,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
              ),
              const SizedBox(height: 5),
              if (imagesLength > 1)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.image!.asMap().entries.map((entry) {
                      final int index = entry.key;
                      return IgnorePointer(
                        ignoring: true,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              currentIndex = index;
                              carouselKey = UniqueKey();
                            });
                          },
                          child: Container(
                            width: 10.0,
                            height: 10.0,
                            margin: const EdgeInsets.symmetric(horizontal: 6.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentIndex == index
                                  ? theme.indicatorColor
                                  : theme.shadowColor,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],

            if (widget.message.isNotEmpty) ...[
              Text(
                widget.message,
                style: TextStyle(
                  color:
                      //  isSender ? theme.primaryColor :
                      theme.primaryColorDark,
                ),
              ),
              const SizedBox(height: 5), // Add space between message and time
            ]
          ],
        ),
      ),
    );
  }
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

class MovingMessages extends StatefulWidget {
  final Color color;

  final bool isClosed;
  const MovingMessages(
      {super.key, required this.color, required this.isClosed});

  @override
  State<MovingMessages> createState() => _MovingMessagesState();
}

class _MovingMessagesState extends State<MovingMessages> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: widget.color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.isClosed == true
                  ? "The Ticket is Closed"
                  : "Please Wait for the Support to Respond !.",
              style: textH1.copyWith(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}
