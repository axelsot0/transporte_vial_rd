import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ExternalMapImpl extends StatefulWidget {
  final String url;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const ExternalMapImpl({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  State<ExternalMapImpl> createState() => _ExternalMapImplState();
}

class _ExternalMapImplState extends State<ExternalMapImpl> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final host = Uri.tryParse(request.url)?.host;
            final baseHost = Uri.tryParse(widget.url)?.host;
            if (host != null && baseHost != null && host == baseHost) {
              return NavigationDecision.navigate;
            } else {
              _launchExternal(request.url);
              return NavigationDecision.prevent;
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  Future<void> _launchExternal(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.zero,
      child: SizedBox(
        width: widget.width ?? double.infinity,
        height: widget.height ?? 300,
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
