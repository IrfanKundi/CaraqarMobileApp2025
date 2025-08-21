import 'package:careqar/services/geocoding_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationMapWidget extends StatefulWidget {
  final String? cityName;
  final double height;

  const LocationMapWidget({
    Key? key,
    required this.cityName,
    this.height = 250,
  }) : super(key: key);

  @override
  _LocationMapWidgetState createState() => _LocationMapWidgetState();
}

class _LocationMapWidgetState extends State<LocationMapWidget> {
  LatLng? cityCoordinates;
  bool isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _loadCityCoordinates();
  }

  Future<void> _loadCityCoordinates() async {
    debugPrint("SAHAr ➡️ _loadCityCoordinates() called");

    if (widget.cityName != null && widget.cityName!.isNotEmpty) {
      debugPrint("SAHAr 🏙️ City name provided: ${widget.cityName}");

      try {
        final coordinates = await GeocodingService.getCoordinatesFromCity(widget.cityName!);
        debugPrint("SAHAr📍 Coordinates received: $coordinates");

        setState(() {
          cityCoordinates = coordinates;
          isLoadingLocation = false;
        });
      } catch (e, stackTrace) {
        debugPrint("SAHAr ❌ Error while fetching coordinates: $e");
        debugPrint("SAHAr 📝 StackTrace: $stackTrace");

        setState(() {
          isLoadingLocation = false;
        });
      }
    } else {
      debugPrint("SAHAr ⚠️ No city name provided.");
      setState(() {
        isLoadingLocation = false;
      });
    }

    debugPrint("SAHAr ✅ _loadCityCoordinates() finished");
  }


  @override
  Widget build(BuildContext context) {
    if (isLoadingLocation) {
      return Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (cityCoordinates != null && widget.cityName != null) {
      return Container(
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: GoogleMap(
                zoomGesturesEnabled: false,
                zoomControlsEnabled: false,
                scrollGesturesEnabled: false,
                rotateGesturesEnabled: false,
                tiltGesturesEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: cityCoordinates!,
                  zoom: 12,
                ),
                markers: {},
              ),
        ),
      );
    }

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          'Location not available',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }
}