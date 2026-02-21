import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';

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
      return Future.error('Location permissions are permanently denied');
    } 

    return await Geolocator.getCurrentPosition();
  }

  Future<PrayerTimes?> getPrayerTimes() async {
    try {
      final position = await _determinePosition();
      final coordinates = Coordinates(position.latitude, position.longitude);
      final params = CalculationMethod.muslim_world_league.getParameters();
      params.madhab = Madhab.shafi;
      
      final prayerTimes = PrayerTimes.today(coordinates, params);
      return prayerTimes;
    } catch (e) {
      print('Error getting prayer times: $e');
      return null;
    }
  }
}
