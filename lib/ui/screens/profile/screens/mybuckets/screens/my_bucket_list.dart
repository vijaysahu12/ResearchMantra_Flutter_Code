import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/payment_gateway/payment_gateway_provider.dart';
import 'package:research_mantra_official/ui/components/common_error/no_connection.dart';
import 'package:research_mantra_official/ui/components/common_error/oops_screen.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/mybuckets/widget/my_bucket.dart';
import 'package:research_mantra_official/ui/screens/scanners/screens/widgets/subscribe_scanners_card.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';
import '../../../../../../providers/mybucket/my_bucket_list_provider.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';

class MyBucketList extends ConsumerStatefulWidget {
  const MyBucketList({super.key});

  @override
  ConsumerState<MyBucketList> createState() => _MyBucketListState();
}

class _MyBucketListState extends ConsumerState<MyBucketList> with RouteAware {
  final UserSecureStorageService _commonDetails = UserSecureStorageService();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _checkAndFetch(true);
    });
  }

  //handle to stopNotofocation or start notification
  void hanldeToToggleNotifications(isToggleNotification, productId) async {
    final String mobileUserPublicKey = await _commonDetails.getPublicKey();
    ref.read(myBucketListProvider.notifier).manageAllowNotification(
        isToggleNotification, mobileUserPublicKey, productId);
  }

  Future<void> _checkAndFetch(isRefresh) async {
    final String mobileUserPublicKey = await _commonDetails.getPublicKey();
    final connectivityResult = ref.watch(connectivityStreamProvider);
    //Checking result based on that displaying connection screen
    final connectionResult = connectivityResult.value;
    if (connectionResult != ConnectivityResult.none) {
      await ref
          .read(myBucketListProvider.notifier)
          .getMyBucketListItems(mobileUserPublicKey, isRefresh);
    } else {
      ToastUtils.showToast(noInternetConnectionText, "");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    bool isPaymentDone = ref
            .watch(paymentStatusNotifier)
            .paymentResponseModel
            ?.paymentStatus
            ?.toLowerCase() ==
        "success";
    if (isPaymentDone) {
      _checkAndFetch(true);
    }
  }

  @override
  void dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
  }

  @override
  Widget build(BuildContext context) {
    final getMyBucketdata = ref.watch(myBucketListProvider);

    final theme = Theme.of(context);
    final connectivityResult = ref.watch(connectivityStreamProvider);

    //if getMyBucketdata is loading loader is genarates
    if (getMyBucketdata.isLoading) {
      return const CommonLoaderGif();
    } else if (getMyBucketdata.error != null) {
      return Scaffold(
        backgroundColor: theme.primaryColor,
        body: const Center(child: ErrorScreenWidget()),
      );
    }

    //Checking result based on that displaying connection screen
    final result = connectivityResult.value;
    if (result == ConnectivityResult.none &&
        getMyBucketdata.myBucketListApiResponseModel.isEmpty) {
      // Show a no internet screen if there is no connectivity
      return NoInternet(handleRefresh: () => _checkAndFetch(false));
    }

    //If My bucket Screen is Empty Subscription Card is Visible
    if (getMyBucketdata.myBucketListApiResponseModel.isEmpty) {
      return Center(
        child:
            ExclusiveTradingInsightsCard(isResearch: false, isScanner: false),
      );
    }
    //Added pull to refresh indicator
    return RefreshIndicator(
      onRefresh: () => _checkAndFetch(false),
      child: ListView.builder(
        itemCount: getMyBucketdata.myBucketListApiResponseModel.length,
        itemBuilder: (context, index) {
          final myBucketItemDetails =
              getMyBucketdata.myBucketListApiResponseModel[index];
          final bool isShowReminder = myBucketItemDetails.showReminder;

          DateTime? startdate = myBucketItemDetails.startdate;
          DateTime? enddate = myBucketItemDetails.enddate;

          String formattedStartDate =
              DateFormat('dd-MMM-yyyy').format(startdate);
          String formattedEndDate = DateFormat('dd-MMM-yyyy').format(enddate);

          return MyBucketListWidget(
              hanldeToToggleNotifications: hanldeToToggleNotifications,
              myBucketItemDetails:
                  getMyBucketdata.myBucketListApiResponseModel[index],
              isShowReminder: isShowReminder,
              formattedStartDate: formattedStartDate,
              formattedEndDate: formattedEndDate);
        },
      ),
    );
  }
}
