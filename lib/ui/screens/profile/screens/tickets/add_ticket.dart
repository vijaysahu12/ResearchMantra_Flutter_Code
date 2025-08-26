import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/tickets/tickets_provider.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/button.dart';
import 'package:research_mantra_official/ui/components/community/image_picker_bottom_sheet.dart';
import 'package:research_mantra_official/ui/components/dropdown/dropdown.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/tickets/widgets/discription_widget.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';
import 'package:research_mantra_official/utils/utils.dart';

class AddTicketPopUp extends ConsumerStatefulWidget {
  final String ticketType;
  final String priority;
  final String subjectText;
  final String description;
  final String ticketTextButton;

  const AddTicketPopUp({
    super.key,
    required this.ticketType,
    required this.priority,
    required this.subjectText,
    required this.description,
    required this.ticketTextButton,
  });

  @override
  ConsumerState<AddTicketPopUp> createState() => _AddTicketPopUpState();
}

class _AddTicketPopUpState extends ConsumerState<AddTicketPopUp> {
  final UserSecureStorageService _secureStorageService =
      UserSecureStorageService();
  final TextEditingController subjectEditingController =
      TextEditingController();
  final TextEditingController descriptionEditingController =
      TextEditingController();
  String? selectedTicketType;
  String? selectedPriority;
  final LayerLink _ticketTypeLayerLink = LayerLink();
  final LayerLink _priorityLayerLink = LayerLink();
  OverlayEntry? _ticketTypeDropdownOverlayEntry;
  OverlayEntry? _priorityDropdownOverlayEntry;
  Map<String, dynamic>? body;
//ticket types
  final Map<String, String> ticketTypeMap = {
    'TEC': 'Technical',
    'SAL': 'Sales',
    'OTH': 'Others',
  };

//priority types
  final Map<String, String> priorityMap = {
    'H': 'High',
    'M': 'Medium',
    'L': 'Low',
  };

  List<String> aspectRatios = [];
  List<XFile> files = [];

//checking the form was filled or not
  bool get isFormFilled {
    return descriptionEditingController.text.trim().isNotEmpty &&
        subjectEditingController.text.trim().isNotEmpty &&
        selectedPriority != null &&
        selectedTicketType != null;
  }

//clear selected image
  Future<void> clearSelectedImage(int index) async {
    setState(() {
      files.removeAt(index);
    });
  }

// Function to post the tickets
  void handleAddTicket(context) async {
    final String mobileUserPublicKey =
        await _secureStorageService.getPublicKey();
    List<File>? fileList = files.map((xFile) => File(xFile.path)).toList();
    if (isFormFilled) {
      Navigator.pop(context);
      if (widget.ticketTextButton == "Add") {
        await ref.read(getAllTicketsStateProvider.notifier).manageTicketList(
              mobileUserPublicKey,
              descriptionEditingController.text,
              subjectEditingController.text,
              selectedPriority!,
              selectedTicketType!,
              fileList,
              aspectRatios,
            );
      }
    } else {
      ToastUtils.showToast(formisEmptyTextMessage, '');
    }
  }

//init state
  @override
  void initState() {
    super.initState();
    subjectEditingController.text = widget.subjectText;
    descriptionEditingController.text = widget.description;

    selectedPriority = widget.priority.isEmpty ? 'M' : widget.priority;
    selectedTicketType = widget.ticketType.isEmpty ? 'OTH' : widget.ticketType;
  }

//DropDown for TicketType
  OverlayEntry _createTicketTypeDropdownOverlay() {
    return OverlayEntry(
      builder: (context) {
        final theme = Theme.of(context);
        final ticketTypeEntries = ticketTypeMap.entries.toList();
        return Positioned(
          width: 135,
          child: CompositedTransformFollower(
            link: _ticketTypeLayerLink,
            showWhenUnlinked: false,
            offset: const Offset(12, 40),
            child: Material(
              elevation: 4.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: theme.primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: theme.focusColor.withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  children: List.generate(ticketTypeEntries.length, (index) {
                    final entry = ticketTypeEntries[index];
                    return Column(
                      children: [
                        DropdownMenuItemWidget(
                          value: entry.key,
                          onSelect: (value) {
                            setState(() {
                              selectedTicketType = value;
                            });
                            _ticketTypeDropdownOverlayEntry?.remove();
                            _ticketTypeDropdownOverlayEntry = null;
                          },
                          displayText: entry.value,
                        ),
                        if (index < ticketTypeEntries.length - 1)
                          const Divider(),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

//DropDown for Priority
  OverlayEntry _createPriorityDropdownOverlay() {
    return OverlayEntry(
      builder: (context) {
        final theme = Theme.of(context);
        final priorityEntries = priorityMap.entries.toList();
        return Positioned(
          width: 134,
          child: CompositedTransformFollower(
            link: _priorityLayerLink,
            showWhenUnlinked: false,
            offset: const Offset(12, 40),
            child: Material(
              elevation: 4.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: theme.primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: theme.focusColor.withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  children: List.generate(priorityEntries.length, (index) {
                    final entry = priorityEntries[index];
                    return Column(
                      children: [
                        DropdownMenuItemWidget(
                          value: entry.key,
                          onSelect: (value) {
                            setState(() {
                              selectedPriority = value;
                            });
                            _priorityDropdownOverlayEntry?.remove();
                            _priorityDropdownOverlayEntry = null;
                          },
                          displayText: entry.value,
                        ),
                        if (index < priorityEntries.length - 1) const Divider(),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

//function to open  ticket type  dropdown
  void _toggleTicketTypeDropdown() {
    if (_ticketTypeDropdownOverlayEntry == null) {
      _ticketTypeDropdownOverlayEntry = _createTicketTypeDropdownOverlay();
      Overlay.of(context).insert(_ticketTypeDropdownOverlayEntry!);
      handleToRemovePriorityDropDown();
    } else {
      handleToRemoveTicketTypeDropDown();
    }
  }

//function to open  priority type  dropdown
  void _togglePriorityDropdown() {
    if (_priorityDropdownOverlayEntry == null) {
      _priorityDropdownOverlayEntry = _createPriorityDropdownOverlay();
      Overlay.of(context).insert(_priorityDropdownOverlayEntry!);
      handleToRemoveTicketTypeDropDown();
    } else {
      handleToRemovePriorityDropDown();
    }
  }

  //handle to remove priority dropdown
  void handleToRemovePriorityDropDown() {
    _priorityDropdownOverlayEntry?.remove();
    _priorityDropdownOverlayEntry = null;
  }

  //handle to remove priority dropdown
  void handleToRemoveTicketTypeDropDown() {
    _ticketTypeDropdownOverlayEntry?.remove();
    _ticketTypeDropdownOverlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;

    return Center(
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        backgroundColor: theme.primaryColorLight,
        child: GestureDetector(
          onTap: () {
            handleToRemovePriorityDropDown();
            handleToRemoveTicketTypeDropDown();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: theme.appBarTheme.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: theme.focusColor.withOpacity(0.4),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      addTicketTitle,
                      style: TextStyle(
                          fontFamily: fontFamily,
                          color: theme.primaryColorDark,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTicketTypeAndPriority(theme),
                  const SizedBox(height: 5),
                  _buildSubject(),
                  const SizedBox(height: 5),
                  DescriptionWidget(
                      height: height,
                      handleToRemovePriorityDropDown:
                          handleToRemovePriorityDropDown,
                      handleToRemoveTicketTypeDropDown:
                          handleToRemoveTicketTypeDropDown,
                      descriptionEditingController:
                          descriptionEditingController),
                  const SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    runSpacing: 10,
                    spacing: 10,
                    alignment: WrapAlignment.start,
                    children: List.generate(
                        files.length,
                        (index) => Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.only(left: 2, top: 1),
                                  child: Image.file(
                                    File(files[index].path),
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
                            )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
                  Row(
                    children: [
                      const Spacer(),
                      Button(
                        text: widget.ticketTextButton,
                        onPressed: () {
                          handleAddTicket(context);
                        },
                        backgroundColor: theme.indicatorColor,
                        textColor:
                            theme.floatingActionButtonTheme.foregroundColor,
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//Widget for Subject
  Widget _buildSubject() {
    final theme = Theme.of(context);
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: theme.primaryColor,
        boxShadow: [
          BoxShadow(
            color: theme.focusColor.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        maxLength: 20,
        controller: subjectEditingController,
        onChanged: (value) {
          setState(() {});
        },
        onTap: () {
          handleToRemovePriorityDropDown();
          handleToRemoveTicketTypeDropDown();
        },
        decoration: InputDecoration(
            counterText: "",
            hintText: "Subject",
            hintStyle: TextStyle(
                fontSize: 13,
                color: theme.focusColor,
                fontWeight: FontWeight.w600),
            border: InputBorder.none),
      ),
    );
  }

//Widget for TicketsType and Priority
  Widget _buildTicketTypeAndPriority(ThemeData theme) {
    return SizedBox(
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _toggleTicketTypeDropdown,
              child: CompositedTransformTarget(
                link: _ticketTypeLayerLink,
                child: Container(
                  height: 40,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: theme.primaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: theme.focusColor.withOpacity(0.4),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ticketTypeMap[selectedTicketType ?? 'OTH'] ??
                            "Ticket Type",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: fontFamily,
                          color: theme.primaryColorDark,
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: theme.primaryColorDark,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: _togglePriorityDropdown,
              child: CompositedTransformTarget(
                link: _priorityLayerLink,
                child: Container(
                  height: 40,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: theme.primaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: theme.focusColor.withOpacity(0.4),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        priorityMap[selectedPriority ?? 'M'] ?? "Priority",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: fontFamily,
                          color: theme.primaryColorDark,
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: theme.primaryColorDark,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//Todo: We have to use this method in common file
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
}
