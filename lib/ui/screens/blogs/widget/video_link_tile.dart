import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/storage.dart';
import 'package:research_mantra_official/data/models/community/community_data_model.dart';
import 'package:research_mantra_official/services/url_launcher_helper.dart';
import 'package:research_mantra_official/ui/components/expanded/expanded_widget.dart';
import 'package:research_mantra_official/ui/components/query_form/form.dart';
import 'package:research_mantra_official/ui/screens/blogs/widget/community_image_viewer.dart';
import 'package:research_mantra_official/ui/screens/profile/widgets/full_screen_image_dialog.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:research_mantra_official/utils/utils.dart';

class UpcomingEventLinkTile extends StatefulWidget {
  final Post linkTile;

  const UpcomingEventLinkTile({
    super.key,
    required this.linkTile,
  });

  @override
  State<UpcomingEventLinkTile> createState() => _UpcomingEventLinkTileState();
}

class _UpcomingEventLinkTileState extends State<UpcomingEventLinkTile> {
  bool isExpanded = false;
  void showFullScreenImage(
      BuildContext context, imageUrl, ImageProvider imageProvider) {
    Navigator.of(context).push(MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return FullScreenImageDialog(
              imageProvider: imageProvider, imageUrl: '');
        },
        fullscreenDialog: true));
  }

  //Handle to navigate Query form screen
  void handleToNavigateQueryForm(id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QueryFormPage(
          id: id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final fontSize = width;

    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        border: Border.all(color: theme.focusColor.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title & Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.linkTile.title ?? "",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: fontSize * 0.035,
                    fontFamily: fontFamily,
                    color: theme.primaryColorDark,
                  ),
                ),
              ),
              if (widget.linkTile.upComingEvent != null)
                Text(
                  Utils.formatDateTime(
                    dateTimeString: widget.linkTile.upComingEvent ?? '',
                    format: ddmmtt,
                  ),
                  style: TextStyle(
                      fontSize: fontSize * 0.024,
                      color: theme.focusColor,
                      fontWeight: FontWeight.w600),
                ),
            ],
          ),
          const SizedBox(height: 10),
          /// Content with Expand/Collapse
          ExpandableText(
            text: widget.linkTile.content,
            trimLength: 200,
            textStyle: TextStyle(
              fontSize: fontSize * 0.03,
              fontFamily: fontFamily,
              color: theme.primaryColorDark,
            ),
            linkStyle: TextStyle(
              fontSize: fontSize * 0.03,
              fontWeight: FontWeight.w600,
              fontFamily: fontFamily,
              color: theme.indicatorColor,
            ),
          ),

          const SizedBox(height: 10),

          /// Image
          if (widget.linkTile.imageUrl != null)
            AspectRatio(
              aspectRatio: 2,
              child: GestureDetector(
                onTap: () => showFullScreenImage(
                  context,
                  "",
                  NetworkImage(widget.linkTile.imageUrl ?? ""),
                ),
                child: CommunityImageViewer(
                  imageURL: widget.linkTile.imageUrl ?? "",
                ),
              ),
            ),

          const SizedBox(height: 10),

          /// Buttons: Query Form & Join
          Row(
            children: [
              if (widget.linkTile.isQueryFormEnabled == true)
                _buildActionButton(
                  context: context,
                  icon: Icons.question_answer,
                  label: "Query Form",
                  onTap: () =>
                      handleToNavigateQueryForm(widget.linkTile.productId),
                  color: theme.focusColor,
                ),
              // const SizedBox(width: 16),
              if (widget.linkTile.isJoinNowEnabled == true)
                _buildActionButton(
                  context: context,
                  icon: Icons.play_arrow,
                  label: "Join the Event",
                  onTap: () async {
                    await UrlLauncherHelper.launchUrlIfPossible(
                        widget.linkTile.url ?? '');
                  },
                  color: theme.focusColor,
                  iconColor: theme.primaryColorDark,
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Reusable action button builder
  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
    Color? iconColor,
  }) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 6,
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 6,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: theme.shadowColor, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 15, color: iconColor ?? color),
              const SizedBox(width: 6),
              Text(
                label,
                style: textStandard.copyWith(
                  fontSize: width * 0.025,
                  fontWeight: FontWeight.w600,
                  fontFamily: fontFamily,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
