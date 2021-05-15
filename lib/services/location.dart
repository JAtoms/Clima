import 'package:clima/utilities/constants.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  dynamic locationEndPoint;

  Future<dynamic> getGeoLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      return locationEndPoint =
          'lat=${position.latitude}&lon=${position.longitude}';
    } catch (e) {
      print(e.toString());
    }
  }
}
