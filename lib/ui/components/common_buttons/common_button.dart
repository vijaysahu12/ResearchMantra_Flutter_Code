import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class ScrollableButtonList extends StatefulWidget {
  final List<String> buttonLabels;
  final int selectedIndex;
  final Function(int) onButtonTap;
  final ThemeData theme;
  final bool showSecondButton;
  const ScrollableButtonList({
    super.key,
    required this.buttonLabels,
    required this.selectedIndex,
    required this.onButtonTap,
    required this.theme,
    this.showSecondButton = true,
  });

  @override
  State<ScrollableButtonList> createState() => _ScrollableButtonListState();
}

class _ScrollableButtonListState extends State<ScrollableButtonList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToIndex(int index) {
    const buttonWidth = 120.0;
    final position = buttonWidth * index - (buttonWidth * 1);

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        position.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.buttonLabels.length > 3) {
      // Scrollable version for more than 2 buttons
      return SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: _buildButtonContainer(),
      );
    } else {
      // Full width version for 2 or fewer buttons
      return _buildButtonContainer(isFullWidth: true);
    }
  }

  Widget _buildButtonContainer({bool isFullWidth = false}) {
    return Container(
      width: isFullWidth ? MediaQuery.of(context).size.width : null,
      decoration: widget.buttonLabels.isEmpty
          ? null
          : BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: widget.theme.shadowColor,
                  width: 1,
                ),
              ),
            ),
      child: Row(
        mainAxisAlignment: isFullWidth
            ? MainAxisAlignment.spaceEvenly
            : MainAxisAlignment.start,
        children: List.generate(
          // widget.showSecondButton
          // ?
          widget.buttonLabels.length,
          // : widget.buttonLabels.length.clamp(0, 2),
          (index) => _buildButtonWrapper(index, isFullWidth),
        ),
      ),
    );
  }

  Widget _buildButtonWrapper(int index, bool isFullWidth) {
    return Expanded(
      flex: isFullWidth ? 1 : 0,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: widget.selectedIndex == index
                  ? widget.theme.disabledColor
                  : widget.theme.primaryColor,
              width: 2,
            ),
          ),
        ),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 8.0), // Adjusted padding
          child: _buildButton(
            context,
            index,
            widget.selectedIndex,
            widget.theme,
            widget.buttonLabels[index],
            isFullWidth,
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, int index, int selectedIndex,
      ThemeData theme, String text, bool isFullWidth) {
    return InkWell(
      borderRadius: BorderRadius.circular(1),
      onTap: () {
        widget.onButtonTap(index);
        if (!isFullWidth) {
          _scrollToIndex(index);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: MediaQuery.of(context).size.width * 0.03,
            color: selectedIndex == index
                ? theme.primaryColorDark
                : theme.focusColor,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
        ),
      ),
    );
  }
}

///////CUSTOM TAB BAR

class CustomTabBar extends StatelessWidget {
  final TabController tabController;
  final List<String> tabTitles;

  const CustomTabBar({
    super.key,
    required this.tabController,
    required this.tabTitles,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isScrollable = tabTitles.length > 2;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: theme.appBarTheme.backgroundColor,
      child: TabBar(
        controller: tabController,
        isScrollable: isScrollable, // Full width tabs
        labelColor: theme.primaryColorDark,
        unselectedLabelColor: theme.focusColor,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.disabledColor,
              width: 2,
            ),
          ),
        ),
        labelPadding:
            isScrollable ? EdgeInsets.only(right: 20) : EdgeInsets.zero,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: screenWidth * 0.035,
        ),
        tabs: tabTitles
            .map(
              (title) => Container(
                alignment: Alignment.center,
                height: screenWidth * 0.1, // Adjust height if needed
                child: Text(title),
              ),
            )
            .toList(),
      ),
    );
  }
}

//two Test
class CustomTabBarTwo extends StatefulWidget {
  final TabController tabController;
  final List<String> tabTitles;
  final List<Icon> tabIcons; // 👈 Add this

  const CustomTabBarTwo({
    super.key,
    required this.tabController,
    required this.tabTitles,
    required this.tabIcons, // 👈 And this
  });

  @override
  State<CustomTabBarTwo> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBarTwo> {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = widget.tabController;
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isScrollable = widget.tabTitles.length > 3;
    final tabCount = widget.tabTitles.length;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(tabCount, (index) {
          final bool isSelected = _tabController.index == index;

          return GestureDetector(
            onTap: () => _tabController.animateTo(index),
            child: Container(
              width: isScrollable ? null : screenWidth / tabCount * 0.9,
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 8),
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected ? theme.disabledColor : theme.primaryColor,
                border: Border.all(
                    color: isSelected ? theme.disabledColor : theme.focusColor,
                    width: 0.5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.tabIcons[index].icon,
                    size: 16, // 👈 Resize here
                    color: isSelected
                        ? theme.floatingActionButtonTheme.foregroundColor
                        : theme.focusColor, // 👈 Dynamic color
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.tabTitles[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.025,
                      color: isSelected
                          ? theme.floatingActionButtonTheme.foregroundColor
                          : theme.focusColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
