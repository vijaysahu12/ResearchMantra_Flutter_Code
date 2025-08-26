import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/common_payment_screen/instamojo_payment_screen.dart';
import 'package:research_mantra_official/ui/components/common_payment_screen/payment_review_screen.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class InstamojoPaymentScreen extends ConsumerStatefulWidget {
  final String productName;
  final String paymentUrl;
  final String paymentRequestId;

  const InstamojoPaymentScreen({
    super.key,
    required this.paymentUrl,
    required this.productName,
    required this.paymentRequestId,
  });

  @override
  ConsumerState<InstamojoPaymentScreen> createState() =>
      _InstamojoPaymentScreenState();
}

class _InstamojoPaymentScreenState extends ConsumerState<InstamojoPaymentScreen>
    with WidgetsBindingObserver {
  late final WebViewController _controller;
  bool isLoading = true;
  bool isRedirectingToUpi = false;
  final UserSecureStorageService _commonDetails = UserSecureStorageService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) => _handleNavigationRequest(request),
          onPageFinished: (_) {
            _setLoadingState(false);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _setLoadingState(bool value) {
    if (mounted && isLoading != value) {
      setState(() => isLoading = value);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && isRedirectingToUpi) {
      _controller.currentUrl().then((url) {
        if (url != null) {
          _navigateToSuccessScreen(
              ref, context, widget.productName, widget.paymentRequestId);
        } else {
          Navigator.pop(context); // Cancelled
        }
      });
      isRedirectingToUpi = false;
    }
  }

  void _onBackPressed() {
    _navigateToSuccessScreen(ref, context, widget.productName, "");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// 🌐 Handle navigation in WebView
  NavigationDecision _handleNavigationRequest(NavigationRequest request) {
    final url = request.url;
    final uri = Uri.tryParse(url);

    // ✅ Payment done — redirect to confirmation screen
    if (url.contains('transaction_id')) {
      _navigateToSuccessScreen(
        ref,
        context,
        widget.productName,
        widget.paymentRequestId,
      );
      return NavigationDecision.prevent;
    }

    // ✅ Safe to navigate in WebView
    if (uri != null) {
      final scheme = uri.scheme;

      if (scheme == 'http' || scheme == 'https') {
        return NavigationDecision.navigate;
      }

      // ✅ UPI scheme redirection
      if (_isUpiScheme(scheme)) {
        isRedirectingToUpi = true;

        // 🧠 Microtask to prevent crashing WebView while launching external intent
        Future.microtask(() {
          _launchAppOrFallback(uri);
        });

        return NavigationDecision.prevent;
      }
    }

    return NavigationDecision.navigate;
  }

  bool _isUpiScheme(String scheme) {
    return scheme == 'phonepe' ||
        scheme == 'paytm' ||
        scheme == 'googlepay' ||
        scheme == 'upi' ||
        scheme.startsWith('intent') ||
        scheme.startsWith('market') ||
        scheme.startsWith('app');
  }

  void _navigateToSuccessScreen(
      ref, context, String productName, String? merchantTransactionId) async {
    String mobileUserKey = await _commonDetails.getPublicKey();
    if (!context.mounted) return;
    if (merchantTransactionId == null || merchantTransactionId.isEmpty) {
      Navigator.pop(context); // Close the current screen
      InstaMojoPaymentUtils().handleTransactionFailure("merchantTransactionId",
          "merchantTransactionId $merchantTransactionId  issue", context);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentProgressScreen(
              merchantTransactionId: merchantTransactionId,
              productName: productName,
              mobileUserKey: mobileUserKey),
        ),
      );
    }
  }

  Future<void> _launchAppOrFallback(Uri uri) async {
    try {
      if (uri.scheme == 'intent') {
        await _handleIntentScheme(uri);
        return;
      }

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } else {
        _openPlayStoreFallback(uri);
      }
    } catch (e) {
      print("Error launching app: $e");
      _openPlayStoreFallback(uri);
    }
  }

  Future<void> _handleIntentScheme(Uri uri) async {
    final String intentUrl = uri.toString();

    try {
      final upiUrl =
          intentUrl.replaceFirst('intent://', 'upi://').split(';').first;
      final upiUri = Uri.parse(upiUrl);

      if (await canLaunchUrl(upiUri)) {
        await launchUrl(upiUri, mode: LaunchMode.platformDefault);
        return;
      }

      final segments = intentUrl.split(';');
      String? packageName;

      for (String segment in segments) {
        if (segment.startsWith('package=')) {
          packageName = segment.replaceFirst('package=', '');
          break;
        }
      }

      if (packageName != null) {
        final playStoreUri = Uri.parse(
            'https://play.google.com/store/apps/details?id=$packageName');
        if (await canLaunchUrl(playStoreUri)) {
          await launchUrl(playStoreUri, mode: LaunchMode.externalApplication);
        }
      } else {
        _openPlayStoreFallback(uri);
      }
    } catch (e) {
      print("Error handling intent scheme: $e");
      _openPlayStoreFallback(uri);
    }
  }

  Future<void> _openPlayStoreFallback(Uri uri) async {
    final playStoreUrls = {
      'phonepe':
          'https://play.google.com/store/apps/details?id=com.phonepe.app',
      'paytm': 'https://play.google.com/store/apps/details?id=net.one97.paytm',
      'googlepay':
          'https://play.google.com/store/apps/details?id=com.google.android.apps.nbu.paisa.user',
    };

    final fallbackUrl = playStoreUrls[uri.scheme];
    if (fallbackUrl != null) {
      final playStoreUri = Uri.parse(fallbackUrl);
      if (await canLaunchUrl(playStoreUri)) {
        await launchUrl(playStoreUri, mode: LaunchMode.externalApplication);
      }
    } else {
      print("No fallback URL found for scheme: ${uri.scheme}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        _onBackPressed();
        return false;
      },
      child: Scaffold(
        backgroundColor: theme.appBarTheme.backgroundColor,
        appBar: CommonAppBarWithBackButton(
          appBarText: widget.productName,
          handleBackButton: () {
           _onBackPressed();
          },
        ),
        body: 
        isLoading
            ? 
            const CommonLoaderGif()
           : WebViewWidget(controller: _controller),
      ),
    );
  }
}
