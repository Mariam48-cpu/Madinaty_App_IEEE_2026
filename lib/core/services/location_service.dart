import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@injectable
class LocationService {
  Future<Position?> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return null;
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings:  LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (_) {
      return null;
    }
  }
}
