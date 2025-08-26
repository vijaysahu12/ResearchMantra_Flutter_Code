import 'package:connectivity_plus_platform_interface/src/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/tickets/ticket_response_model.dart';
import 'package:research_mantra_official/providers/tickets/tickets_provider.dart';
import 'package:research_mantra_official/ui/components/common_error/no_connection.dart';
import 'package:research_mantra_official/ui/components/common_error/oops_screen.dart';
import 'package:research_mantra_official/ui/components/empty_contents/no_content_widget.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/tickets/screens/single_ticket_screen.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/tickets/widgets/support_cards.dart';

class TicketListWidget extends ConsumerStatefulWidget {
  final Function(BuildContext, String, String, String, String, String)
      showAddTickets;
  final String? selectedStatus;
  final List<TicketResponseModel> filteredTickets;
  final void Function() handleToRemoveDropDown;
  final ConnectivityResult? connectionResult;
  final Future<void> Function() handleGetAllTickets;
  const TicketListWidget({
    super.key,
    this.selectedStatus,
    required this.filteredTickets,
    required this.showAddTickets,
    required this.handleToRemoveDropDown,
    this.connectionResult,
    required this.handleGetAllTickets,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<TicketListWidget> {
  void handleToNavigateTicketChatScreen(ticketId, ticketTitle, initChatMessgae,
      String priority, String ticketStatus) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SingleTicketScreen(
                  title: ticketTitle,
                  ticketId: ticketId,
                  priority: priority,
                  chatMessgae: initChatMessgae,
                  ticketStatus: ticketStatus,
                )));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final alltickets = ref.watch(getAllTicketsStateProvider);

    List<TicketResponseModel> filteredTickets = widget.filteredTickets;
    if (widget.selectedStatus == "Open") {
      filteredTickets = alltickets.ticketResponseModel
          .where((ticket) => ticket.status == "O")
          .toList();
    } else if (widget.selectedStatus == "Closed") {
      filteredTickets = alltickets.ticketResponseModel
          .where((ticket) => ticket.status == "C")
          .toList();
    } else if (widget.selectedStatus == 'All') {
      filteredTickets = alltickets.ticketResponseModel;
    }

    if (widget.connectionResult == ConnectivityResult.none) {
      return NoInternet(
        handleRefresh: widget.handleGetAllTickets,
      );
    } else if (alltickets.isLoading) {
      return const CommonLoaderGif();
    } else if (alltickets.error != null) {
      return const Center(
        child: ErrorScreenWidget(),
      );
    } else if (alltickets.ticketResponseModel.isEmpty) {
      return const NoContentWidget(
        message: noTicketsText,
      );
    }

    String? priority;
    String? ticketType;
    Color priorityColor;

    return ListView.builder(
      itemCount: filteredTickets.length,
      itemBuilder: (context, index) {
        if (filteredTickets[index].priority == "H") {
          priority = "High";
          priorityColor = theme.disabledColor;
        } else if (filteredTickets[index].priority == "M") {
          priority = "Medium";
          priorityColor = Colors.yellow; //Todo:We have to change the color
        } else {
          priority = "Low";
          priorityColor = Colors.orange;
        }
        if (filteredTickets[index].ticketType == "SAL") {
          ticketType = "Sales";
        } else if (filteredTickets[index].ticketType == "TEC") {
          ticketType = "Technical";
        } else {
          ticketType = "Others";
        }

        return AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 100),
          child: SlideAnimation(
            verticalOffset: 100.0,
            child: FadeInAnimation(
              child: GestureDetector(
                onTap: () {
                  widget.handleToRemoveDropDown();
                  handleToNavigateTicketChatScreen(
                    filteredTickets[index].id,
                    filteredTickets[index].subject,
                    filteredTickets[index].description,
                    filteredTickets[index].priority,
                    filteredTickets[index].status,
                  );
                },
                child: SizedBox(
                  height: MediaQuery.of(context).size.width * 0.25,
                  width: double.infinity,
                  child: SupportCards(
                    priority: filteredTickets[index].priority,
                    createdOn: filteredTickets[index].createdOn ??
                        DateTime.now().toString(),
                    description: filteredTickets[index].ticketType,
                    iconButton: IconButton(
                        onPressed: () {},
                        icon: filteredTickets[index].status == "O"
                            ? Icon(
                                Icons.open_in_browser,
                                color: theme.primaryColorDark,
                              )
                            : Icon(
                                Icons.close,
                                color: theme.primaryColorDark,
                              )),
                    title: "${filteredTickets[index].subject}  ",
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
