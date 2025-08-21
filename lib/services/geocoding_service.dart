import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeocodingService {
  static Future<LatLng?> getCoordinatesFromCity(String cityName) async {
    try {
      if (cityName.isEmpty) return null;

      List<Location> locations = await locationFromAddress(cityName);
      if (locations.isNotEmpty) {
        return LatLng(locations.first.latitude, locations.first.longitude);
      }
      return null;
    } catch (e) {
      print('Error getting coordinates for $cityName: $e');
      return null;
    }
  }

  static Future<String?> getCityFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        return placemarks.first.locality ?? placemarks.first.administrativeArea;
      }
      return null;
    } catch (e) {
      print('Error getting city from coordinates: $e');
      return null;
    }
  }
}