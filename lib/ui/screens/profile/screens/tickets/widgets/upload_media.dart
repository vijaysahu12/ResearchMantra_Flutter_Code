import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/tickets/message_response_model.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/tickets/message/message_provider.dart';
import 'package:research_mantra_official/services/check_connectivity.dart';
import 'package:research_mantra_official/ui/components/community/image_picker_bottom_sheet.dart';
import 'package:research_mantra_official/ui/components/words/negative_words.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';
import 'package:research_mantra_official/utils/utils.dart';

class UploadMediaScreen extends ConsumerStatefulWidget {
  final String mobileUserPublicKey;
  final int ticketId;
  final String supportTextMessage;
  final List<Messages> message;
  const UploadMediaScreen({
    super.key,
    required this.mobileUserPublicKey,
    required this.ticketId,
    required this.supportTextMessage,
    required this.message,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UploadMediaScreenState();
}

class _UploadMediaScreenState extends ConsumerState<UploadMediaScreen> {
  List<String> aspectRatios = [];
  List<XFile> files = [];
  Map<String, dynamic>? body;
  bool hasBadWords = false;
  Future<void> clearSelectedImage(int index) async {
    setState(() {
      files.removeAt(index);
    });
  }

  late final TextEditingController supportTextEditController;

  @override
  void initState() {
    super.initState();
    supportTextEditController = TextEditingController();
    supportTextEditController.text = widget.supportTextMessage;
    supportTextEditController.addListener(_onContentChanged); //
  }

// Listener method
  void _onContentChanged() {
    setState(() {
      // Update the local variable whenever the text changes
      hasBadWords = containBadwords(supportTextEditController.text.toString());
    });
  }

  void _sendMessage() async {
    final bool value = await _checkAndFetch();
    List<File>? fileList = files.map((xFile) => File(xFile.path)).toList();
    if (value) {
      await ref.read(getAllMessageStateProvider.notifier).addMessagge(
            widget.ticketId,
            supportTextEditController.text.trim(),
            widget.mobileUserPublicKey,
            widget.message,
            fileList,
            aspectRatios,
          );
      // _supportTextEditController.clear();
      // setState(() {
      //   hasBadWords = true;
      // });

      FocusManager.instance.primaryFocus?.unfocus();
      Navigator.pop(context);
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

//Todo:
  // Helper method to handle image picking
  Future<void> handleImagePick({
    required Future<Map<String, dynamic>?> Function(BuildContext)
        pickerFunction,
    required bool isCamera,
  }) async {
    if (files.length > 2) {
      // Replace with your actual Toast utility
      ToastUtils.showToast(imageLimitText, "");
      return;
    }

    final body = await pickerFunction(context);
    if (body != null) {
      XFile xFile = body['file'];
      String aspectRatio = body['aspectRatioLabel'];

      setState(() {
        files.add(xFile);
        aspectRatios.add(aspectRatio);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  children: [
                    _buildContent(context),
                    SizedBox(
                      height: 200, // Adjust height as needed
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: files.length,
                        itemBuilder: (context, index) {
                          if (index < files.length) {
                            // Display newly selected images
                            return Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.only(left: 2, top: 1),
                                  child: Image.file(
                                    File(files[index].path),
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => clearSelectedImage(index),
                                  child: Icon(
                                    Icons.cancel,
                                    color: theme.primaryColor,
                                  ),
                                ),
                              ],
                            );
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomNavigationBar(context)
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            height: 1.0,
            color: theme.primaryColor,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.cancel_outlined,
            size: 25,
            color: theme.primaryColorDark,
          ),
        ),
        title: Row(
          children: [
            const Spacer(),
            if (files.isNotEmpty ||
                supportTextEditController.text.trim().isNotEmpty)
              TextButton(
                  style: ElevatedButton.styleFrom(
                      overlayColor: Colors.grey,
                      backgroundColor: theme.indicatorColor),
                  onPressed: () {
                    _sendMessage();
                    // widget.existingBlogId.isEmpty
                    //     ? handlePostBlog(context)
                    //     : handleBlogEditPost(context, widget.existingBlogId);
                  },
                  child: Text(
                    "Post",
                    style: TextStyle(
                        fontSize: 12,
                        color: theme.floatingActionButtonTheme.foregroundColor,
                        fontWeight: FontWeight.bold),
                  )),
          ],
        ));
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: theme.appBarTheme.backgroundColor),
      child: Column(
        children: [
          ImagePickerOptions(
            theme: theme,
            onCameraTap: () async {
              await handleImagePick(
                pickerFunction: Utils.pickImageFromCamera,
                isCamera: true,
              );
            },
            onGalleryTap: () async {
              await handleImagePick(
                pickerFunction: Utils.pickImageFromGallery,
                isCamera: false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    // _contentController.addListener(() {
    //   setState(() {});
    // });
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            child: TextField(
              controller: supportTextEditController,
              maxLength: 200,
              autofocus: true,
              style: TextStyle(
                color: theme.primaryColorDark,
                fontFamily: fontFamily,
                fontSize: 14,
              ),
              maxLines: null,
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
                hintText: postHintText,
                hintStyle: TextStyle(fontSize: 14, fontFamily: fontFamily),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
