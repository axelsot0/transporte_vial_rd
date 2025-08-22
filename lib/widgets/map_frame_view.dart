import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Modelo de una parada. Puedes pasar address O latLng.
/// [name] es el texto que se mostrará en el InfoWindow.
class MapStop {
  final String name;
  final String? address;
  final LatLng? latLng;
  

  const MapStop({
    required this.name,
    this.address,
    this.latLng,
  }) : assert(address != null || latLng != null,
       'Debes proveer address o latLng');
}

enum MapTravelMode { driving, walking, bicycling, transit }

/// Modelo de una ruta con varias paradas.
/// La primera parada es el origen y la última es el destino.
class MapRoute {
  final String id;
  final List<MapStop> stops;
  final MapTravelMode mode;

  const MapRoute({
    required this.id,
    required this.stops,
    this.mode = MapTravelMode.driving,
  }) : assert(stops.length >= 2, 'Una ruta necesita al menos origen y destino');
}

class MapFrameView extends StatefulWidget {
  final List<MapRoute> routes;
  final bool allowUserToAddRoute;

  const MapFrameView({
    super.key,
    required this.routes,
    this.allowUserToAddRoute = true,
  });

  @override
  State<MapFrameView> createState() => _MapFrameViewState();
}

class _MapFrameViewState extends State<MapFrameView> {
  final _controller = Completer<GoogleMapController>();
  final _markers = <Marker>{};
  final _polylines = <Polyline>{};

  static const _fallbackCenter = LatLng(18.479153, -69.918727);

  @override
  void initState() {
    super.initState();
    _drawAll();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: _fallbackCenter,
            zoom: 12,
          ),
          onMapCreated: (c) => _controller.complete(c),
          markers: _markers,
          polylines: _polylines,
          zoomControlsEnabled: false,
          compassEnabled: true,
          myLocationEnabled: false,
        ),
        if (widget.allowUserToAddRoute)
          Positioned(
            right: 12,
            bottom: 12,
            child: FloatingActionButton.extended(
              onPressed: _promptNewRoute,
              icon: const Icon(Icons.add),
              label: const Text('Add route'),
            ),
          ),
      ],
    );
  }

  Future<void> _drawAll() async {
    _markers.clear();
    _polylines.clear();

    final allPointsForBounds = <LatLng>[];

    for (var r = 0; r < widget.routes.length; r++) {
      final route = widget.routes[r];
      final color = _colorForIndex(r);

      final coords = await _ensureLatLngs(route.stops);
      if (coords.length < 2) continue;

      // Markers (A, B, C…)
      final letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
      for (int i = 0; i < coords.length; i++) {
        final letter = String.fromCharCode(65 + (i % 26));
        final hue = i == 0
            ? BitmapDescriptor.hueAzure
            : (i == coords.length - 1
                ? BitmapDescriptor.hueRed
                : BitmapDescriptor.hueOrange);

        _markers.add(Marker(
          markerId: MarkerId('${route.id}_$i'),
          position: coords[i],
          icon: BitmapDescriptor.defaultMarkerWithHue(hue),
          infoWindow: InfoWindow(title: '$letter · ${route.stops[i].name}'),
        ));
        allPointsForBounds.add(coords[i]);
      }

      // Directions polyline
      final points = await _fetchDirectionsPolyline(
        origin: coords.first,
        destination: coords.last,
        waypoints: coords.length > 2 ? coords.sublist(1, coords.length - 1) : const [],
        mode: route.mode,
      );

      _polylines.add(Polyline(
        polylineId: PolylineId('poly_${route.id}'),
        points: points,
        width: 6,
        color: color,
      ));
    }

    if (allPointsForBounds.isNotEmpty && _controller.isCompleted) {
      final bounds = _boundsFor(allPointsForBounds);
      final map = await _controller.future;
      await map.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
    }

    if (mounted) setState(() {});
  }

  /// Dialogo simple para agregar una ruta escribiendo paradas (1 por línea).
  Future<void> _promptNewRoute() async {
    final controller = TextEditingController(
      text: 'Origen, Santo Domingo\nAv. Duarte, Santo Domingo\nÁgora Mall, Santo Domingo',
    );
    final mode = ValueNotifier<MapTravelMode>(MapTravelMode.driving);

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nueva ruta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Escribe una parada por línea (primera=origen, última=destino)'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              minLines: 4,
              maxLines: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Parada 1\nParada 2\nParada 3',
              ),
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder(
              valueListenable: mode,
              builder: (_, m, __) => DropdownButton<MapTravelMode>(
                value: m,
                items: const [
                  DropdownMenuItem(
                    value: MapTravelMode.driving, child: Text('Driving')),
                  DropdownMenuItem(
                    value: MapTravelMode.walking, child: Text('Walking')),
                  DropdownMenuItem(
                    value: MapTravelMode.bicycling, child: Text('Bicycling')),
                  DropdownMenuItem(
                    value: MapTravelMode.transit, child: Text('Transit')),
                ],
                onChanged: (v) => mode.value = v ?? MapTravelMode.driving,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Agregar')),
        ],
      ),
    );

    if (ok != true) return;

    final lines = controller.text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (lines.length < 2) return;

    final newRoute = MapRoute(
      id: 'r${DateTime.now().millisecondsSinceEpoch}',
      mode: mode.value,
      stops: lines.map((name) => MapStop(name: name, address: name)).toList(),
    );

    setState(() {
      widget.routes.add(newRoute); // nota: routes debe venir como List mutable
    });

    await _drawAll();
  }

  // Utils ------------- //

  Color _colorForIndex(int i) {
    const palette = [
      Color(0xFF4285F4), // azul
      Color(0xFF0F9D58), // verde
      Color(0xFFDB4437), // rojo
      Color(0xFFF4B400), // amarillo
      Color(0xFFAA46BB), // morado
    ];
    return palette[i % palette.length];
  }

  LatLngBounds _boundsFor(List<LatLng> pts) {
    var minLat = pts.first.latitude, maxLat = pts.first.latitude;
    var minLng = pts.first.longitude, maxLng = pts.first.longitude;
    for (final p in pts) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  Future<List<LatLng>> _ensureLatLngs(List<MapStop> stops) async {
  final key = _apiKey();
  final result = <LatLng>[];
  for (final s in stops) {
    if (s.latLng != null) {
      result.add(s.latLng!);
    } else if (s.address != null && key.isNotEmpty) { // 👈 aquí
      final ll = await _geocode(s.address!, key);
      if (ll != null) result.add(ll);
    }
  }
  return result;
}


  Future<LatLng?> _geocode(String address, String apiKey) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json'
      '?address=${Uri.encodeQueryComponent(address)}&key=$apiKey',
    );
    final res = await http.get(url);
    if (res.statusCode != 200) return null;
    final data = json.decode(res.body);
    if (data['status'] != 'OK' || (data['results'] as List).isEmpty) return null;
    final loc = data['results'][0]['geometry']['location'];
    return LatLng((loc['lat'] as num).toDouble(), (loc['lng'] as num).toDouble());
  }

  Future<List<LatLng>> _fetchDirectionsPolyline({
    required LatLng origin,
    required LatLng destination,
    required List<LatLng> waypoints,
    required MapTravelMode mode,
  }) async {
    String _apiKey() {
  // Para Web usa --dart-define si quieres llamar a Directions REST desde el cliente
  const fromDefine = String.fromEnvironment('GOOGLE_MAPS_API_KEY');
  if (fromDefine.isNotEmpty) return fromDefine;

  // Para móviles/escritorio lee .env
  try {
    // Si dotenv no está inicializado, atrapamos el error y devolvemos vacío.
    return _apiKey() ?? '';
  } catch (_) {
    return '';
  }
}

    final key = _apiKey();
    if (key == null) return [origin, ...waypoints, destination];

    final originStr = '${origin.latitude},${origin.longitude}';
    final destStr = '${destination.latitude},${destination.longitude}';
    final wpStr = waypoints.map((w) => '${w.latitude},${w.longitude}').join('|');

    final modeStr = switch (mode) {
      MapTravelMode.driving => 'driving',
      MapTravelMode.walking => 'walking',
      MapTravelMode.bicycling => 'bicycling',
      MapTravelMode.transit => 'transit',
    };

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json'
      '?origin=$originStr&destination=$destStr'
      '${waypoints.isNotEmpty ? '&waypoints=$wpStr' : ''}'
      '&mode=$modeStr&key=$key',
    );

    

    final res = await http.get(url);
    if (res.statusCode != 200) return [origin, ...waypoints, destination];
    final data = json.decode(res.body);
    if (data['status'] != 'OK') return [origin, ...waypoints, destination];

    final encoded = data['routes'][0]['overview_polyline']['points'] as String;
    final decoded = PolylinePoints().decodePolyline(encoded);
    return decoded.map((p) => LatLng(p.latitude, p.longitude)).toList();
  }
}
String _apiKey() {
  // Para Web usa --dart-define si quieres llamar a Directions REST desde el cliente
  const fromDefine = String.fromEnvironment('GOOGLE_MAPS_API_KEY');
  if (fromDefine.isNotEmpty) return fromDefine;

  // Para móviles/escritorio lee .env
  try {
    // Si dotenv no está inicializado, atrapamos el error y devolvemos vacío.
    return dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
  } catch (_) {
    return '';
  }
}
