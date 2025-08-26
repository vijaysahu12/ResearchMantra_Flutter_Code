import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/payment_gateway/payment_gateway_provider.dart';
import 'package:research_mantra_official/services/check_connectivity.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/screens/home/home_navigator.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/mybuckets/my_bucket_list_screen.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

class PaymentProgressScreen extends ConsumerStatefulWidget {
  final String productName;
  final String mobileUserKey;
  final String merchantTransactionId;

  const PaymentProgressScreen({
    super.key,
    required this.productName,
    required this.merchantTransactionId,
    required this.mobileUserKey,
  });

  @override
  ConsumerState<PaymentProgressScreen> createState() =>
      _PaymentProgressScreenState();
}

class _PaymentProgressScreenState extends ConsumerState<PaymentProgressScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isPaymentStatusLoading = true;

  @override
  void initState() {
    super.initState();
    HapticFeedback.lightImpact();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handlePaymentConfirmation();
    });

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
  }

  Future<void> _handlePaymentConfirmation() async {
    setState(() => isPaymentStatusLoading = true);

    final isConnected =
        await CheckInternetConnection().checkInternetConnection();
    if (!isConnected) {
      ToastUtils.showToast(noInternetConnectionText, "");
      if (mounted) {
        setState(() => isPaymentStatusLoading = false);
      }
      return;
    }

    if (!mounted) return;

    final notifier = ref.read(paymentStatusNotifier.notifier);
    await notifier.getpaymentStatus(widget.merchantTransactionId, 'INSTAMOJO');

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => isPaymentStatusLoading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _popMultipleScreens(int count) {
    int popped = 0;
    while (Navigator.canPop(context) && popped < count) {
      Navigator.pop(context);
      popped++;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    final notifier = ref.watch(paymentStatusNotifier);
    final paymentResponseModel = notifier.paymentResponseModel;
    final isSuccess = paymentResponseModel?.paymentStatus == 'SUCCESS';
    final startDate = paymentResponseModel?.startDate;
    final endDate = paymentResponseModel?.endDate;
    final productValidity = paymentResponseModel?.productValidity ?? 0;

    return WillPopScope(
      onWillPop: () async {
        _popMultipleScreens(3);
        return false;
      },
      child: Scaffold(
        appBar: CommonAppBarWithBackButton(
          appBarText: "Payment Processing",
          handleBackButton: () => _popMultipleScreens(3),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        body: isPaymentStatusLoading
            ? CommonLoaderGif()
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: [
                      SizedBox(height: 15.h),
                      _buildProgressIcon(theme, isSuccess),
                      SizedBox(height: 10.h),
                      _buildProcessingSubtitle(theme, isSuccess),
                      SizedBox(height: 35.h),
                      _buildProductCard(
                          theme, fontSize, startDate, endDate, productValidity),
                      SizedBox(height: 15.h),
                      _buildStatusCard(
                          theme, fontSize, startDate, endDate, isSuccess),
                      SizedBox(height: 10.h),
                      if (!isSuccess) _buildVerificationNotice(theme, fontSize),
                      const Spacer(),
                      _buildNavigationButton(
                          context, theme, fontSize, isSuccess),
                      SizedBox(height: 5.h),
                      _buildNote(theme, fontSize),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildProgressIcon(ThemeData theme, bool isSuccess) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.85, end: 1.1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: Container(
        width: 75,
        height: 75,
        decoration: BoxDecoration(
          color: isSuccess ? theme.secondaryHeaderColor : Colors.orange,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isSuccess ? Icons.check_circle_outline_rounded : Icons.loop,
          color: theme.floatingActionButtonTheme.foregroundColor,
          size: 50,
        ),
      ),
    );
  }

  Widget _buildProcessingSubtitle(ThemeData theme, bool isSuccess) {
    return Text(
      isSuccess
          ? 'Payment Successful! Product has been activated.'
          : 'Please wait while we process your transaction',
      style: TextStyle(
        fontSize: 12.sp,
        color: theme.focusColor,
        letterSpacing: 0.2,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildProductCard(ThemeData theme, double fontSize, String? start,
      String? end, int productValidity) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: theme.shadowColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: fontSize * 0.1,
                height: fontSize * 0.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: theme.floatingActionButtonTheme.foregroundColor,
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: theme.secondaryHeaderColor,
                  size: fontSize * 0.05,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Course Details',
                style: TextStyle(
                  fontSize: fontSize * 0.034,
                  fontWeight: FontWeight.bold,
                  color: theme.focusColor,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
              label: "Course",
              value: widget.productName,
              theme: theme,
              fontSize: fontSize),
          if (productValidity > 0)
            _buildInfoRow(
              label: "Service Duration",
              value: "$productValidity Days",
              theme: theme,
              fontSize: fontSize,
            ),
          if (start != null && end != null)
            _buildInfoRow(
              label: "Service Period",
              value: "$start to $end",
              theme: theme,
              fontSize: fontSize,
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required ThemeData theme,
    required double fontSize,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontSize * 0.032,
                fontWeight: FontWeight.w600,
                color: theme.primaryColorDark,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: fontSize * 0.031,
                fontWeight: FontWeight.w500,
                color: theme.primaryColorDark,
                overflow: TextOverflow.ellipsis,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(theme, fontSize, start, end, bool isSuccess) {
    final message = isSuccess
        ? "✅ Your payment has been confirmed. Your subscription is now active and ready to use.\n🔹 Service Start: $start \n🔹 Service End: $end \nThank you for choosing us!"
        : "Your payment is being processed. Payment confirmation and product activation may take up to 30 minutes. You’ll be notified once everything is complete.";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: theme.shadowColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: TextStyle(
          fontSize: fontSize * 0.035,
          fontWeight: FontWeight.w500,
          color: theme.focusColor,
          letterSpacing: 0.5,
          height: 1.8,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildVerificationNotice(ThemeData theme, double fontSize) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: theme.disabledColor.withOpacity(0.4),
      ),
      child: Text(
        "🔐	We’re verifying your payment. Please avoid making another attempt during this period.",
        style: TextStyle(
          fontSize: fontSize * 0.03,
          fontWeight: FontWeight.w500,
          color: theme.floatingActionButtonTheme.foregroundColor,
          letterSpacing: 0.2,
          height: 1.8,
        ),
      ),
    );
  }

  Widget _buildNavigationButton(
      BuildContext context, ThemeData theme, double fontSize, bool isSuccess) {
    final buttonText = isSuccess ? 'Go To My Bucket' : 'Back To Dashboard';

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          if (isSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const MyBucketListScreen(isDirect: true)),
            );
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (_) => const HomeNavigatorWidget(initialIndex: 0)),
              (_) => false,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.secondaryHeaderColor,
          foregroundColor: theme.floatingActionButtonTheme.foregroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: fontSize * 0.035,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildNote(ThemeData theme, double fontSize) {
    return Text(
      '🔔 Note: If the amount wasn’t deducted, please try again.',
      style: TextStyle(
        fontSize: fontSize * 0.022,
        color: theme.focusColor,
      ),
    );
  }
}
