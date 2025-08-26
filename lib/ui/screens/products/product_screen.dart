import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/products/list/product_list_provider.dart';
import 'package:research_mantra_official/ui/components/common_buttons/common_button.dart';
import 'package:research_mantra_official/ui/components/empty_contents/no_content_widget.dart';
import 'package:research_mantra_official/ui/screens/products/screens/productlist/products_list_screen.dart';

class AllProducts extends ConsumerStatefulWidget {
  final bool isFromHome;

  const AllProducts({super.key, this.isFromHome = false});

  @override
  ConsumerState<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends ConsumerState<AllProducts> {
  late PageController _pageController;
  int selectedIndex = 0;
  
  @override
  void initState() {
    super.initState();

    selectedIndex = widget.isFromHome ? 1 : 0;
    _pageController = PageController(initialPage: selectedIndex);

    Future.microtask(() {
      ref
          .read(algoButtonsStateNotifierProvider.notifier)
          .setButtonState(selectedIndex);
    });
  }

  void _onPageChanged(int index) {
    ref.read(algoButtonsStateNotifierProvider.notifier).setButtonState(index);
    setState(() {
      selectedIndex = index;
    });
  }

  void _onButtonTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    ref.read(algoButtonsStateNotifierProvider.notifier).setButtonState(index);
  }

  @override
  void dispose() {
    
    // Dispose the page controller
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsList = ref.watch(productsStateNotifierProvider);
    final loading = productsList.isLoading;

final strategyList = productsList.productApiResponseModel
    .where((e) => e.groupName.toLowerCase() == "strategy")
    .toList();

final courseList = productsList.productApiResponseModel
    .where((e) => e.groupName.toLowerCase() == "course")
    .toList();

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Column(
        children: [
          const SizedBox(height: 5),
          ScrollableButtonList(
            buttonLabels: const [algoButton2, algoButton1],
            selectedIndex: selectedIndex,
            onButtonTap: _onButtonTap,
            theme: theme,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
  (strategyList.isEmpty && !loading)
      ? const NoContentWidget(message: productScreenEmptyTitle)
      : ProductListScreen(typeOfButton: "strategy"),

  (courseList.isEmpty && !loading)
      ? const NoContentWidget(message: productScreenEmptyTitle)
      : ProductListScreen(typeOfButton: "course"),
],
            ),
          ),
        ],
      ),
    );
  }
}
