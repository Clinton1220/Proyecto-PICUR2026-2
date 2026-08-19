import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/status_dot.dart';
import 'report_zone_page.dart';

class RiskMapPage extends StatefulWidget {
  const RiskMapPage({super.key});

  @override
  State<RiskMapPage> createState() => _RiskMapPageState();
}

class _RiskMapPageState extends State<RiskMapPage> {
  final MapController _mapController = MapController();
  Position? _currentPosition;
  LatLng? _pendingPosition;
  String? _message;
  Stream<Position>? _positionStream;
  bool _mapReady = false;

  static const _defaultCenter = LatLng(19.4312, -99.1344);

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final hasPermission = await _checkPermission();
    if (!hasPermission) return;

    const settings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 10,
    );

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: settings,
      );
      _updatePosition(position);

      _positionStream = Geolocator.getPositionStream(
        locationSettings: settings,
      );
      _positionStream?.listen(_updatePosition);
    } catch (e) {
      if (!mounted) return;
      setState(() => _message = 'No se pudo obtener ubicación: $e');
    }
  }

  Future<bool> _checkPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _message =
          'Activa la ubicación en tu dispositivo para ver el mapa en tiempo real.');
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      setState(() => _message =
          'Permite el acceso a la ubicación para ver el mapa en tiempo real.');
      return false;
    }
    return true;
  }

  void _updatePosition(Position position) {
    final location = LatLng(position.latitude, position.longitude);
    setState(() {
      _currentPosition = position;
      _message = null;
      if (!_mapReady) {
        _pendingPosition = location;
      }
    });
    if (_mapReady) {
      _mapController.move(location, 14);
    }
  }

  List<Marker> _buildMarkers() {
    final center = _currentPosition != null
        ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
        : _defaultCenter;

    final locations = [
      _RiskLocation(
        label: 'Riesgo alto',
        coord: '${center.latitude + 0.0010}, ${center.longitude + 0.0010}',
        position: LatLng(center.latitude + 0.0010, center.longitude + 0.0010),
        color: const Color(0xFFF44336),
        status: 'Riesgo alto',
      ),
      _RiskLocation(
        label: 'Precaución',
        coord: '${center.latitude - 0.0010}, ${center.longitude - 0.0010}',
        position: LatLng(center.latitude - 0.0010, center.longitude - 0.0010),
        color: const Color(0xFFFFC107),
        status: 'Precaución',
      ),
      _RiskLocation(
        label: 'Seguro',
        coord: '${center.latitude + 0.0010}, ${center.longitude - 0.0010}',
        position: LatLng(center.latitude + 0.0010, center.longitude - 0.0010),
        color: const Color(0xFF4CAF50),
        status: 'Seguro',
      ),
    ];

    final markers = locations
        .map((location) => Marker(
              width: 240,
              height: 80,
              point: location.position,
              child: _RiskMarkerCard(location: location),
            ))
        .toList();

    if (_currentPosition != null) {
      markers.add(Marker(
        width: 56,
        height: 56,
        point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        child: const _UserLocationMarker(),
      ));
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final center = _currentPosition != null
        ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
        : _defaultCenter;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de riesgo'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Ubicaciones de riesgo detectadas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (_message != null)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(_message!, style: const TextStyle(fontSize: 14)),
              ),
            const SizedBox(height: 12),
            if (_currentPosition == null && _message == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: CircularProgressIndicator()),
              ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: center,
                    initialZoom: 14,
                    minZoom: 4,
                    maxZoom: 18,
                    onMapReady: () {
                      setState(() {
                        _mapReady = true;
                      });
                      final pending = _pendingPosition;
                      if (pending != null) {
                        _mapController.move(pending, 14);
                        _pendingPosition = null;
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                      userAgentPackageName: 'com.example.geo_guardian',
                    ),
                    MarkerLayer(markers: _buildMarkers()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatusDot(color: Color(0xFF4CAF50), label: 'Seguro'),
                StatusDot(color: Color(0xFFFFC107), label: 'Precaución'),
                StatusDot(color: Color(0xFFF44336), label: 'Riesgo alto'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ReportZonePage()),
                      );
                    },
                    child: const Text('Reportar zona'),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: _initLocation,
                  child: const Text('Reintentar ubicación'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RiskLocation {
  final String label;
  final String coord;
  final LatLng position;
  final Color color;
  final String status;

  const _RiskLocation({
    required this.label,
    required this.coord,
    required this.position,
    required this.color,
    required this.status,
  });
}

class _RiskMarkerCard extends StatelessWidget {
  final _RiskLocation location;

  const _RiskMarkerCard({required this.location});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${location.label}: ${location.status}'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        width: 240,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_pin, color: location.color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(location.label,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(location.coord,
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 6),
            Text(location.status,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: location.color)),
          ],
        ),
      ),
    );
  }
}

class _UserLocationMarker extends StatelessWidget {
  const _UserLocationMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.9),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: const Icon(Icons.my_location, color: Colors.white, size: 28),
    );
  }
}
