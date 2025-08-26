import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/community/community_type_model.dart';
import 'package:research_mantra_official/providers/blogs/main/report/report_provider.dart';
import 'package:research_mantra_official/ui/components/common_buttons/common_button.dart';
import 'package:research_mantra_official/ui/screens/blogs/screens/community/annoucement_screen.dart';
import 'package:research_mantra_official/ui/screens/blogs/screens/community/link_list.dart';
import 'package:research_mantra_official/ui/screens/blogs/screens/community/video_list.dart';

class CoummnunityBaseScreen extends ConsumerStatefulWidget {
  final List<PostType>? postTypeData;
  final Product? productTypeData;
  const CoummnunityBaseScreen(
      {this.productTypeData, super.key, required this.postTypeData});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CoummnunityBaseScreenState();
}

class _CoummnunityBaseScreenState extends ConsumerState<CoummnunityBaseScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getReportDataApi();
    });
  }

  Future<void> getReportDataApi() async {
    if (!mounted) return;
    final reportNotifier = ref.read(getReportNotifierProvider.notifier);
    final reportResponseModel =
        ref.read(getReportNotifierProvider).reportResponseModel;

    int length = reportResponseModel?.length ?? 0;

    if (reportResponseModel == null || length == 0) {
      if (!mounted) return;
      await reportNotifier.getReport();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final fontSize = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Column(
        children: [
          // Replace TabBar with CustomTabBar
          CustomTabBarTwo(
            tabController: _tabController,
            tabTitles:
                widget.postTypeData?.map((post) => "${post.name} ").toList() ??
                    [],
            tabIcons: [
              Icon(Icons.group),
              Icon(Icons.smart_display),
              Icon(Icons.link),
            ],
          ),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                AnnouncementScreen(
                  announcemtPostType: widget.postTypeData?[0] ?? PostType(),
                  productTypeData: widget.productTypeData ?? Product(),
                ),
                VideoListScreen(
                  announcemtPostType: widget.postTypeData?[1] ?? PostType(),
                  productTypeData: widget.productTypeData ?? Product(),
                ),
                UpcommingEventsLink(
                  announcemtPostType: widget.postTypeData?[2] ?? PostType(),
                  productTypeData: widget.productTypeData ?? Product(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
