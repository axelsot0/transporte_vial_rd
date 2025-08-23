// Este archivo SOLO se compila en Web (gracias al import condicional en external_map_view.dart)
import 'dart:ui_web' as ui;
import 'dart:html' as html;

import 'package:flutter/material.dart';

class ExternalMapImpl extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  static const _viewTypePrefix = 'external-iframe-view-';

  ExternalMapImpl({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.borderRadius,
  }) {
    final viewType = '$_viewTypePrefix${url.hashCode}';
    try {
      ui.platformViewRegistry.registerViewFactory(viewType, (int _) {
        final iframe = html.IFrameElement()
          ..src = url
          ..style.border = '0'
          ..allow = 'geolocation *; clipboard-read *; clipboard-write *';
        return iframe;
      });
    } catch (_) {
      // Si ya estaba registrado, ignorar
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewType = '$_viewTypePrefix${url.hashCode}';
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: SizedBox(
        width: width ?? double.infinity,
        height: height ?? 300,
        child: const HtmlElementView(viewType: ''),
      ),
    );
  }
}
