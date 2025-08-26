import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/tickets/ticket_response_model.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/tickets/tickets_provider.dart';
import 'package:research_mantra_official/services/check_connectivity.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/dropdown/dropdown.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/tickets/add_ticket.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/tickets/widgets/ticket_list_widget.dart';

class TicketsScreen extends ConsumerStatefulWidget {
  const TicketsScreen({super.key});

  @override
  ConsumerState<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends ConsumerState<TicketsScreen> {
  String? selectedStatus = 'All';
  final UserSecureStorageService _secureStorageService =
      UserSecureStorageService();
  List<TicketResponseModel> filteredTickets = [];
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _dropdownOverlayEntry;

  @override
  void initState() {
    super.initState();
    handleGetAllTickets();
  }

  // Get all tickets
  Future<void> handleGetAllTickets() async {
    final String mobileUserPublicKey =
        await _secureStorageService.getPublicKey();
    bool checkConnection =
        await CheckInternetConnection().checkInternetConnection();

    ref
        .read(connectivityProvider.notifier)
        .updateConnectionStatus(checkConnection);

    if (checkConnection) {
      ref
          .read(getAllTicketsStateProvider.notifier)
          .getAllTicketList(mobileUserPublicKey);
    }
  }

  // Show Add Tickets dialog box function
  void showAddTickets(BuildContext context, ticketType, priority, subjectText,
      description, ticketTextButton) async {
    handleToRemoveDropDown();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AddTicketPopUp(
          ticketType: ticketType,
          priority: priority,
          subjectText: subjectText,
          description: description,
          ticketTextButton: ticketTextButton,
        );
      },
    );
  }

  // Create an overlay entry for the dropdown menu
  OverlayEntry _createDropdownOverlay() {
    return OverlayEntry(
      builder: (context) {
        final theme = Theme.of(context);
        return Positioned(
          width: 200,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: const Offset(0, 48),
            child: Material(
              elevation: 4.0,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.shadowColor,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Column(
                  children: [
                    DropdownMenuItemWidget(
                      value: "All",
                      onSelect: (value) {
                        setState(() {
                          selectedStatus = value;
                        });
                        _dropdownOverlayEntry?.remove();
                        _dropdownOverlayEntry = null;
                      },
                      displayText: "All",
                    ),
                    const Divider(),
                    DropdownMenuItemWidget(
                      value: "Open",
                      onSelect: (value) {
                        setState(() {
                          selectedStatus = value;
                        });
                        _dropdownOverlayEntry?.remove();
                        _dropdownOverlayEntry = null;
                      },
                      displayText: 'Open',
                    ),
                    const Divider(),
                    DropdownMenuItemWidget(
                      value: "Closed",
                      onSelect: (value) {
                        setState(() {
                          selectedStatus = value;
                        });
                        _dropdownOverlayEntry?.remove();
                        _dropdownOverlayEntry = null;
                      },
                      displayText: 'Closed',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _toggleDropdown() {
    if (_dropdownOverlayEntry == null) {
      _dropdownOverlayEntry = _createDropdownOverlay();
      Overlay.of(context).insert(_dropdownOverlayEntry!);
    } else {
      handleToRemoveDropDown();
    }
  }

  //removing the dropdown
  void handleToRemoveDropDown() {
    _dropdownOverlayEntry?.remove();
    _dropdownOverlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CommonAppBarWithBackButton(
        appBarText: supportScreenText,
        handleBackButton: () {
          Navigator.pop(context);
        },
      ),
      body: GestureDetector(
        onTap: () => handleToRemoveDropDown(),
        child: RefreshIndicator(
          onRefresh: () => handleGetAllTickets(),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: _buildStatusSearchAdd(),
              ),
              const SizedBox(height: 1),
              Expanded(
                child: TicketListWidget(
                    handleToRemoveDropDown: handleToRemoveDropDown,
                    showAddTickets: showAddTickets,
                    selectedStatus: selectedStatus,
                    filteredTickets: filteredTickets,
                    handleGetAllTickets: handleGetAllTickets),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for status, search, and add ticket
  Widget _buildStatusSearchAdd() {
    final theme = Theme.of(context);
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _toggleDropdown,
                child: Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                        selectedStatus ?? "Status",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
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
            const SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: theme.indicatorColor,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () => showAddTickets(context, "", "", "", "", "Add"),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.add,
                      color: theme.floatingActionButtonTheme.foregroundColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
