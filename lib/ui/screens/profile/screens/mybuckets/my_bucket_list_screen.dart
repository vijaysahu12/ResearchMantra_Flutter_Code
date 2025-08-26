import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/products/list/product_list_provider.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/common_buttons/common_button.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/mybuckets/screens/invoice_history.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/mybuckets/screens/my_bucket_list.dart';

class MyBucketListScreen extends ConsumerStatefulWidget {
  final bool isDirect;
  const MyBucketListScreen({super.key, required this.isDirect});

  @override
  ConsumerState<MyBucketListScreen> createState() => _MyBucketListScreenState();
}

class _MyBucketListScreenState extends ConsumerState<MyBucketListScreen>
    with SingleTickerProviderStateMixin {
  final UserSecureStorageService _commonDetails = UserSecureStorageService();
  bool _isFirstClick = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<bool> handleBackButton(BuildContext context) async {
    final mobileUserPublicKey = await _commonDetails.getPublicKey();

    if (widget.isDirect && _isFirstClick) {
      ref.read(productsStateNotifierProvider.notifier).getProductList(
            mobileUserPublicKey,
            true,
          );
      _isFirstClick = false;
    }

    Navigator.pop(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () => handleBackButton(context),
      child: Scaffold(
        backgroundColor: theme.primaryColor,
        appBar: CommonAppBarWithBackButton(
          appBarText: myBucketListText,
          handleBackButton: () => handleBackButton(context),
        ),
        body: Column(
          children: [
            CustomTabBar(
                tabController: _tabController,
                tabTitles: ["Products", "History"]),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  MyBucketList(),
                  InvoiceHistoryScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
