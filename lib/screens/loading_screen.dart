import 'package:clima/screens/location_screen.dart';
import 'package:clima/services/location.dart';
import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    makeRequestAndNavigate();
  }

  void makeRequestAndNavigate() async {
    Location location = Location();
    dynamic locationResult = await location.getGeoLocation();

    WeatherModel weatherModel = WeatherModel();
    var weatherResult;

    if (locationResult != null) {
      weatherResult = await weatherModel.getLocationWeather(locationResult);
    }

    if (weatherResult != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return LocationScreen(
          locationWeather: weatherResult,
        );
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitRipple(
          color: Colors.white,
          size: 70.0,
        ),
      ),
    );
  }
}
