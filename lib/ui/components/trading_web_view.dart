 
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/utils/utils.dart';
 
class WebViewScreen extends StatefulWidget {
  final String url;
 
  const WebViewScreen({super.key, required this.url});
 
  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}
 
class _WebViewScreenState extends State<WebViewScreen> {
  InAppWebViewController? webViewController;
  bool isLoading = true;
 
  Future<void> _handleBack() async {
    if (isGetIOSPlatform()) {
      await webViewController?.loadUrl(
        urlRequest: URLRequest(url: WebUri("about:blank")),
      );
      await Future.delayed(const Duration(milliseconds: 150));
    }
    if (mounted) Navigator.pop(context);
  }
 
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
 
    return Scaffold(
      appBar: CommonAppBarWithBackButton(
        appBarText: '',
        handleBackButton: _handleBack,
      ),
      backgroundColor: theme.appBarTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            if (isLoading)
              LinearProgressIndicator(
                color: theme.indicatorColor,
                minHeight: 2,
              ),
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri(widget.url)),
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                onLoadStart: (controller, url) {
                  setState(() => isLoading = true);
                },
                onLoadStop: (controller, url) {
                  setState(() => isLoading = false);
                },
                onCreateWindow: (controller, createWindowRequest) async {
                  return false;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 