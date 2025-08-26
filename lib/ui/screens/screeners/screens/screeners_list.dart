import 'package:flutter/material.dart';
import 'package:research_mantra_official/data/models/screeners/screeners_category_data_model.dart';
import 'package:research_mantra_official/ui/screens/screeners/screens/screeners_filter_list_screen.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class ScreenersListBaseScreen extends StatefulWidget {
  final List<Screener> screenerCategory;
  final int index;
  final String screenerName;
  const ScreenersListBaseScreen(
      {super.key,
      required this.screenerCategory,
      required this.index,
      required this.screenerName});
  @override
  State<ScreenersListBaseScreen> createState() =>
      _ScreenersListBaseScreenState();
}

class _ScreenersListBaseScreenState extends State<ScreenersListBaseScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: widget.screenerCategory.length ?? 0, vsync: this);

    _tabController.animateTo(widget.index);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSize = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.screenerName,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize * 0.045,
              color: theme.primaryColorDark),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: theme.primaryColorDark,
            size: 25,
          ),
        ),
        bottom: TabBar(
          dividerColor: theme.focusColor,
          labelColor: theme.disabledColor,
          indicatorColor: theme.disabledColor,
          indicatorSize: TabBarIndicatorSize.tab,
          padding: const EdgeInsets.all(4),
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          controller: _tabController,
          tabs: List.generate(
            widget.screenerCategory.length ?? 0,
            (index) => Tab(
                child: Text(
              widget.screenerCategory[index].name ?? "",
              style: textH5.copyWith(fontSize: 12),
            )),
          ),
        ),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: List.generate(
          widget.screenerCategory.length ?? 0,
          (index) => ScreenerFilterScreen(
            screenerCategory: widget.screenerCategory[index],
          ),
        ),
      ),
    );
  }
}
