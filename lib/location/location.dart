import 'package:location/location.dart';

class LocationService {
  Location location = Location();

  Future<LocationData> getCurrentLocation() async {
    try {
      LocationData locationData = await location.getLocation();
      return locationData;
    } catch (e) {
      // ignore: avoid_print
      print("Error getting location: $e");
      return LocationData.fromMap({
        "latitude": 0.0,
        "longitude": 0.0,
      }); // Return a default LocationData or handle the error accordingly
    }
  }

  Stream<LocationData> get locationStream => location.onLocationChanged;
}
