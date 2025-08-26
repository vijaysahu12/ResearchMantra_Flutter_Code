import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/partneraccount/partner_account_provider.dart';
import 'package:research_mantra_official/providers/partneraccount/partner_account_state.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/dropdown/dropdown.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/partneraccount/widgets/buttons.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/partneraccount/widgets/partner_apikey.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/partneraccount/widgets/partner_id.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/partneraccount/widgets/partner_name.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/partneraccount/widgets/partner_secretkey.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

final GlobalKey<_MyPartnerAccountState> partnerAccountDetailsKey =
    GlobalKey<_MyPartnerAccountState>();

class PartnerAccountDetails extends ConsumerStatefulWidget {
  final PartnerAccountState partnerAccountState;

  const PartnerAccountDetails({
    super.key,
    required this.partnerAccountState,
  });

  @override
  ConsumerState<PartnerAccountDetails> createState() =>
      _MyPartnerAccountState();
}

class _MyPartnerAccountState extends ConsumerState<PartnerAccountDetails> {
  final UserSecureStorageService _commonDetails = UserSecureStorageService();

  final TextEditingController partnerNameController = TextEditingController();
  final TextEditingController partnerIdController = TextEditingController();
  final TextEditingController partnerApiController = TextEditingController();
  final TextEditingController partnerSecretKeyController =
      TextEditingController();
  String? _selectedPartner;
  final LayerLink _partnerNameLayerLink = LayerLink();
  OverlayEntry? _partnerNameDropdownOverlayEntry;

  @override
  void initState() {
    super.initState();
    if (widget.partnerAccountState.partnerAccountResponseModel != null) {
      partnerNameController.text =
          widget.partnerAccountState.partnerAccountResponseModel!.partnerName;
      partnerIdController.text =
          widget.partnerAccountState.partnerAccountResponseModel!.partnerId;
      partnerApiController.text =
          widget.partnerAccountState.partnerAccountResponseModel!.api;
      partnerSecretKeyController.text =
          widget.partnerAccountState.partnerAccountResponseModel!.secretKey;
    }
    _initializeSelectedPartner();
  }

  bool get isFormFilled {
    return partnerNameController.text.trim().isNotEmpty &&
        partnerIdController.text.trim().isNotEmpty &&
        partnerIdController.text.trim().length > 2 &&
        partnerApiController.text.trim().trim().isNotEmpty &&
        partnerApiController.text.trim().length > 9 &&
        partnerSecretKeyController.text.trim().isNotEmpty &&
        partnerSecretKeyController.text.trim().length > 9;
  }

//Function to add details
  void handlePartnerAccountDetails() async {
    final String mobileUserPublicKey = await _commonDetails.getPublicKey();
    if (isFormFilled) {
      await ref
          .read(partnerAccountProvider.notifier)
          .managePartnerAccountDetailsProvider(
              partnerNameController.text,
              partnerIdController.text,
              partnerApiController.text,
              partnerSecretKeyController.text,
              mobileUserPublicKey);
    } else {
      ToastUtils.showToast(formisEmptyTextMessage, '');
    }
  }

//Function to clear controllers
  void handlePartnerDetailsCancel() {
    partnerIdController.clear();
    partnerApiController.clear();
    partnerSecretKeyController.clear();
  }

//Function to check selectedPartner
  void _initializeSelectedPartner() {
    setState(() {
      _selectedPartner = partnerNameController.text.isNotEmpty
          ? partnerNameController.text
          : (widget.partnerAccountState.partnerNames.isNotEmpty
              ? widget.partnerAccountState.partnerNames.first.data
              : null);
    });
  }

  OverlayEntry createdPartnerNamesDropdownOverlay() {
    return OverlayEntry(builder: (context) {
      final theme = Theme.of(context);
      final partnerNameList = widget.partnerAccountState.partnerNames;
      final height = MediaQuery.of(context).size.height;

      return GestureDetector(
        onTap: handleRemoveToggle,
        child: Stack(
          children: [
            Positioned(
              width: MediaQuery.of(context).size.width - 39,
              child: CompositedTransformFollower(
                link: _partnerNameLayerLink,
                showWhenUnlinked: false,
                offset: Offset(0, height * 0.06),
                child: Material(
                  elevation: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.appBarTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(color: theme.shadowColor),
                    ),
                    child: Column(
                      children: List.generate(
                        partnerNameList.length,
                        (index) {
                          final entry = partnerNameList[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DropdownMenuItemWidget(
                                value: entry.data,
                                onSelect: (value) {
                                  setState(() {
                                    _selectedPartner = value;
                                  });
                                  partnerNameController.text = value;
                                  _partnerNameDropdownOverlayEntry?.remove();
                                  _partnerNameDropdownOverlayEntry = null;
                                },
                                displayText: entry.data,
                              ),
                              Divider(
                                height: 1,
                                color: index < partnerNameList.length - 1
                                    ? Colors.grey // or any visible color
                                    : Colors
                                        .transparent, // <- ensures same layout for last item
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _togglePartnerNamesDropdown() {
    if (_partnerNameDropdownOverlayEntry == null) {
      _partnerNameDropdownOverlayEntry = createdPartnerNamesDropdownOverlay();
      Overlay.of(context).insert(_partnerNameDropdownOverlayEntry!);
    } else {
      handleRemoveToggle();
    }
  }

  void handleRemoveToggle() {
    _partnerNameDropdownOverlayEntry?.remove();
    _partnerNameDropdownOverlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    bool isData =
        widget.partnerAccountState.partnerAccountResponseModel == null;
    return AnimationConfiguration.synchronized(
      duration: const Duration(milliseconds: 500),
      child: GestureDetector(
        onTap: handleRemoveToggle,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              if (widget.partnerAccountState.partnerAccountResponseModel !=
                      null &&
                  widget.partnerAccountState.partnerNames.isNotEmpty)
                PartnerName(
                  selectedPartner: _selectedPartner,
                  partnerNameLayerLink: _partnerNameLayerLink,
                  togglePartnerNamesDropdown: _togglePartnerNamesDropdown,
                ),
              SizedBox(height: 8.h),
              PartnerId(
                partnerIdController: partnerIdController,
                togglePartnerNamesDropdown: handleRemoveToggle,
              ),
              SizedBox(height: 8.h),
              PartnerApiKey(
                partnerApiController: partnerApiController,
                togglePartnerNamesDropdown: handleRemoveToggle,
              ),
              SizedBox(height: 8.h),
              PartnerSecretKey(
                partnerSecretKeyController: partnerSecretKeyController,
                togglePartnerNamesDropdown: handleRemoveToggle,
              ),
              SizedBox(height: 8.h),
              if (widget.partnerAccountState.partnerAccountResponseModel !=
                  null)
                AccountButtons(
                  partnerAccountDetails: widget.partnerAccountState,
                  isData: isData,
                  handlePartnerAccountDetails: handlePartnerAccountDetails,
                  handlePartnerDetailsCancel: handlePartnerDetailsCancel,
                  togglePartnerNamesDropdown: handleRemoveToggle,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
