
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/delete_account/delete_account_statement_provider.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/button.dart';
import 'package:research_mantra_official/ui/components/cacher_network_images/circular_cached_network_image.dart';
import 'package:research_mantra_official/ui/components/innovation_button/developed_button.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

class DeleteAccountScreen extends ConsumerStatefulWidget {
  final String userName;
  final String? selectedGender;
  final String? profileImage;
  const DeleteAccountScreen(
      {super.key,
      required this.userName,
      this.selectedGender,
      this.profileImage});

  @override
  ConsumerState<DeleteAccountScreen> createState() =>
      _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  final List<String> deleteTermsAndConditions = [
    "Deleting your account will result in the permanent loss of all enrolled courses and your learning progress.",
    "All active subscriptions will be canceled, and you will no longer have access to premium content.",
  ];
  final TextEditingController _feedBackTextEditingController =
      TextEditingController();
  final UserSecureStorageService _commonDetails = UserSecureStorageService();

  @override
  void initState() {
    super.initState();

    // Delay the provider modification until after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(getDeleteAccountStatementsProvider.notifier)
          .getAllTheDeleteAccountStatements();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _feedBackTextEditingController.dispose();
  }

//Function To open the DeleteAccount popUp
  void handleDeleteAccountPopUp(BuildContext context, theme) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(child: _buildForDelete(theme));
      },
    ).then((_) {
      _feedBackTextEditingController.clear();
    });
  }

//Function To  DeleteAccount
  void handleToDeleteTheAccount() {
    String feedBackText = _feedBackTextEditingController.text.trim();
    if (feedBackText.isEmpty) {
      ToastUtils.showToast(feedbackCannotEmpty, errorText);
    } else if (feedBackText.length < 20) {
      ToastUtils.showToast(feedbackAtLeastMoreText, errorText);
    } else {
      _commonDetails.handleAccountDelete(
          context, ref, _feedBackTextEditingController.text);
      _feedBackTextEditingController.clear();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final getStatementsState = ref.watch(getDeleteAccountStatementsProvider);
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: theme.primaryColor,
        appBar: CommonAppBarWithBackButton(
          appBarText: deleteAccountbuttonText,
          handleBackButton: () {
            Navigator.pop(context);
          },
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.03,
                ),
                Container(
                  // color: theme.disabledColor,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    color: theme.disabledColor,
                  ),

                  child: widget.profileImage != null
                      ? CircularCachedNetworkImage(
                          imageURL: widget.profileImage!,
                          size: 60,
                          borderColor: theme.shadowColor,
                          type: 'profile',
                        )
                      : CircleAvatar(
                          radius: 30.5,
                          child: SvgPicture.asset(
                            height: 60,
                            // Use the latest gender state to set the corresponding SVG file
                            widget.selectedGender != null &&
                                    widget.selectedGender!.toLowerCase() ==
                                        maleGenderValue
                                ? maleUserProfileSvgFilePath
                                : feamleUserProfileSvgFilePath,
                            fit: BoxFit
                                .cover, // Ensure the SVG covers the avatar
                          ),
                        ),
                ),
                Text(
                  "Hello ${widget.userName}",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: fontFamily,
                      color: theme.primaryColorDark),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Text(
                  thingToCheckWhenDeleting,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: fontFamily,
                      color: theme.primaryColorDark),
                ),
                const SizedBox(
                  height: 10,
                ),
                _buildForDeleteCondtions(theme, getStatementsState),
                const SizedBox(
                  height: 5,
                ),
                Button(
                  text: deleteMyAccountbuttonText,
                  onPressed: () => handleDeleteAccountPopUp(context, theme),
                  backgroundColor: theme.indicatorColor,
                  textColor: theme.floatingActionButtonTheme.foregroundColor,
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                DevelopedByText(),
                SizedBox(
                  height: height * 0.07,
                ),
              ],
            ),
          ),
        ));
  }

  //Widget for deleteTerms and condtions
  Widget _buildForDeleteCondtions(ThemeData theme, getStatementsState) {
    final statements = getStatementsState.isLoading
        ? null
        : getStatementsState.getDeleteAccountStatements?.isNotEmpty == true
            ? getStatementsState.getDeleteAccountStatements
            : deleteTermsAndConditions;

    if (getStatementsState.isLoading) {
      return const CommonLoaderGif();
    }

    return ListView.builder(
      shrinkWrap: true, // Adapts to the content size
      physics:
          const NeverScrollableScrollPhysics(), // Prevents internal scrolling
      itemCount: statements?.length ?? 0,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align bullet and text
            children: [
              // Bullet point
              Padding(
                padding:
                    const EdgeInsets.only(top: 6.0), // Align bullet to text
                child: Icon(
                  Icons.circle,
                  size: 8,
                  color: theme.primaryColorDark,
                ),
              ),
              const SizedBox(width: 8),

              // Text content with multiline support
              Flexible(
                child: Text(
                  statements![index],
                  style: TextStyle(fontSize: 14, color: theme.primaryColorDark),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //Widget for Delete
  Widget _buildForDelete(theme) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: theme.appBarTheme.backgroundColor,
        ),
        height: 550,
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              handImagePath,
              scale: 12,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Flexible(
                  child: Text(
                    deleteAccountPopUpTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: theme.primaryColorDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Flexible(
                  child: Text(
                    deleteAccountPopUpMessage,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: theme.focusColor,
                        fontFamily: fontFamily),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.shadowColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  child: TextField(
                    minLines: 4,
                    maxLines: 4,
                    keyboardType: TextInputType.text,
                    maxLength: 200,
                    controller: _feedBackTextEditingController,
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: deleteAccountPopUpHineText,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: theme.focusColor,
                        fontFamily: fontFamily,
                      ),
                      border: InputBorder.none,
                      // suffixIcon:
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Button(
              text: deleteAccountPopUpconfirmButtonText,
              onPressed: () {
                setState(() {
                  isLoggingout = true;
                });
                handleToDeleteTheAccount();
              },
              backgroundColor: theme.indicatorColor,
              textColor: theme.floatingActionButtonTheme.foregroundColor,
            ),
            const SizedBox(height: 10),
            Button(
              text: deleteAccountPopUpcancelButtonText,
              onPressed: () {
                _feedBackTextEditingController.clear();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              backgroundColor: theme.focusColor,
              textColor: theme.floatingActionButtonTheme.foregroundColor,
            ),
          ],
        ),
      ),
    );
  }
}
