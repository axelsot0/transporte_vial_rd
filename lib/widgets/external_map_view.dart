import 'package:flutter/widgets.dart';

// Implementación condicional: web vs. móvil vs. stub
import 'src/external_map_impl_stub.dart'
  if (dart.library.html) 'src/external_map_impl_web.dart'
  if (dart.library.io) 'src/external_map_impl_mobile.dart';

/// Usa este widget en tus pantallas.
/// Ejemplo:
/// ExternalMapView(url: 'https://maps.google.com/?q=Santo%20Domingo')
class ExternalMapView extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const ExternalMapView({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ExternalMapImpl(
      url: url,
      width: width,
      height: height,
      borderRadius: borderRadius,
    );
  }
}

// Alias opcional si en tu código antiguo usabas ExternalMapIFrame:
class ExternalMapIFrame extends ExternalMapView {
  const ExternalMapIFrame({
    super.key,
    required super.url,
    super.width,
    super.height,
    super.borderRadius,
  });
}
