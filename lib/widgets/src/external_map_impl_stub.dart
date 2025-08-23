import 'package:flutter/material.dart';

class ExternalMapImpl extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 200,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: borderRadius ?? BorderRadius.zero,
      ),
      child: const Text(
        'Vista de mapa no disponible en esta plataforma.',
        textAlign: TextAlign.center,
      ),
    );
  }
}
