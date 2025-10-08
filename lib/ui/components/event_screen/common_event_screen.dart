import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonEventScreen extends StatefulWidget {
  final String url;

  const CommonEventScreen({super.key, required this.url});

  @override
  State<CommonEventScreen> createState() => _CommonEventScreenState();
}

class _CommonEventScreenState extends State<CommonEventScreen> {
  InAppWebViewController? webViewController;
  bool isLoading = true;

  @override
  void dispose() {
    webViewController?.dispose(); // Clean up the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.appBarTheme.backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            /// 🌐 WebView content
            Column(
              children: [
                if (isLoading)
                  LinearProgressIndicator(
                    color: theme.indicatorColor,
                    minHeight: 2,
                  ),
                Expanded(
                  child: InAppWebView(
                    key: ValueKey(widget.url),
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

            /// ❌ Cancel button (top-right)
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: () async {
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 22.w,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
