import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../theme/app_theme.dart';
import 'custom_loader.dart';

/// Generic in-app browser — loads [url] inside the app instead of
/// handing off to an external browser. Reusable anywhere a hosted flow
/// (Stripe Checkout, a help article, an advisor link, ...) needs to open
/// without leaving the app.
///
/// Hosted flows like Stripe Checkout finish by redirecting to a custom
/// URL scheme (e.g. `lightsignal://success`) — that's not a real
/// webpage, so a [WebView] can't load it (`ERR_UNKNOWN_URL_SCHEME`) and
/// it must be intercepted as a deep link instead. Pass [deepLinkScheme]
/// (defaults to `lightsignal`) and [onDeepLink] to catch that redirect
/// before the WebView tries to render it.
class InAppWebViewScreen extends StatefulWidget {
  const InAppWebViewScreen({
    super.key,
    required this.url,
    this.title,
    this.deepLinkScheme = 'lightsignal',
    this.onDeepLink,
    this.onPageFinished,
  });

  final String url;
  final String? title;
  final String deepLinkScheme;
  final ValueChanged<Uri>? onDeepLink;
  final ValueChanged<String>? onPageFinished;

  @override
  State<InAppWebViewScreen> createState() => _InAppWebViewScreenState();
}

class _InAppWebViewScreenState extends State<InAppWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.baseDeep)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (url) {
            if (mounted) setState(() => _isLoading = false);
            widget.onPageFinished?.call(url);
          },
          onNavigationRequest: (request) {
            final uri = Uri.tryParse(request.url);
            if (uri != null && uri.scheme == widget.deepLinkScheme) {
              widget.onDeepLink?.call(uri);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.baseDeep,
      appBar: AppBar(
        backgroundColor: AppColors.baseDeep,
        foregroundColor: AppColors.white,
        title: Text(widget.title ?? '', style: AppTextStyles.logo),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CustomLoader(size: 32)),
        ],
      ),
    );
  }
}
