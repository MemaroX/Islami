import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/foundation.dart';

class PrayerTimesService {
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      if (kIsWeb) {
        return Position(
          longitude: 39.8262, latitude: 21.4225,
          timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0,
          altitudeAccuracy: 0, headingAccuracy: 0,
        );
      }
      return Future.error('Location permissions are permanently denied');
    } 

    return await Geolocator.getCurrentPosition();
  }

  Future<String> getCityName() async {
    try {
      final pos = await _determinePosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (placemarks.isNotEmpty) {
        return '${placemarks.first.locality}, ${placemarks.first.country}';
      }
      return 'Location Found';
    } catch (e) {
      return 'Mecca, Saudi Arabia';
    }
  }

  Future<PrayerTimes?> getPrayerTimes({DateTime? date}) async {
    try {
      final position = await _determinePosition();
      final coordinates = Coordinates(position.latitude, position.longitude);
      final params = CalculationMethod.muslim_world_league.getParameters();
      params.madhab = Madhab.shafi;
      
      final prayerTimes = PrayerTimes(coordinates, DateComponents.from(date ?? DateTime.now()), params);
      return prayerTimes;
    } catch (e) {
      print('Error getting prayer times: $e');
      return null;
    }
  }
}
