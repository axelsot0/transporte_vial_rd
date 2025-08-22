// lib/widgets/external_map_iframe.dart
import 'package:flutter/material.dart';
import 'dart:ui_web' as ui;   // Flutter 3.24+ (web)
import 'dart:html' as html;

class ExternalMapIFrame extends StatefulWidget {
  final String src;
  final BorderRadius borderRadius;
  const ExternalMapIFrame({
    super.key,
    required this.src,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  State<ExternalMapIFrame> createState() => _ExternalMapIFrameState();
}

class _ExternalMapIFrameState extends State<ExternalMapIFrame> {
  late final String _viewType;
  static final Set<String> _registered = {};

  @override
  void initState() {
    super.initState();
    // viewType único por URL, para que puedas cambiar "src" si lo necesitas
    _viewType = 'external-iframe-${widget.src.hashCode}';
    if (!_registered.contains(_viewType)) {
      ui.platformViewRegistry.registerViewFactory(_viewType, (int _) {
        final iframe = html.IFrameElement()
          ..src = widget.src
          ..style.border = '0'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.borderRadius = '16px'       // respeta el redondeo
          ..style.overflow = 'hidden'         // 🔑 oculta scrollbars
          ..setAttribute('loading', 'lazy')
          ..setAttribute('scrolling', 'no');  // 🔑 evita scrollbars clásicos
        return iframe;
      });
      _registered.add(_viewType);
    }
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewType);
  }
}
