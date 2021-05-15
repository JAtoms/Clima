import 'dart:convert';
import 'package:clima/screens/city_screen.dart';
import 'package:clima/services/location.dart';
import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';

class LocationScreen extends StatefulWidget {
  final locationWeather;

  LocationScreen({this.locationWeather});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String mLongitude, mCityName, mWeatherIcon, mMessage;
  num mTemperature, mWeatherCondition;
  var weatherResult;

  WeatherModel weatherModel = WeatherModel();

  @override
  void initState() {
    super.initState();
    upDateUi(widget.locationWeather);
  }

  void makeRequestAndUpdateUiWithLocation() async {
    Location location = Location();
    dynamic locationResult = await location.getGeoLocation();

    if (locationResult != null) {
      weatherResult = await weatherModel.getLocationWeather(locationResult);
    }

    if (weatherResult != null) {
      upDateUi(weatherResult);
      print('Clicked');
    } else {
      print('Error');
    }
  }

  void makeRequestAndUpdateUiWithCityName(String typedCityName) async {
    var cityName = 'q=$typedCityName';
    weatherResult = await weatherModel.getLocationWeather(cityName);

    if (weatherResult != null) {
      upDateUi(weatherResult);
      print('Clicked');
    } else {
      print('Error');
    }
  }

  void upDateUi(dynamic locationWeather) {
    setState(() {
      mLongitude =
          (jsonDecode(locationWeather.body)['coord']['lon']).toString();
      mCityName = jsonDecode(locationWeather.body)['name'];

      mTemperature = (jsonDecode(locationWeather.body)['main']['temp']);
      mTemperature = mTemperature.toInt();

      mWeatherCondition =
          (jsonDecode(locationWeather.body)['weather'][0]['id']);
      mMessage = weatherModel.getMessage(mTemperature.toInt());
      mWeatherIcon = weatherModel.getWeatherIcon(mWeatherCondition.toInt());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          makeRequestAndUpdateUiWithLocation();
                        });
                      },
                      child: Icon(
                        Icons.near_me,
                        size: 30.0,
                      ),
                    ),
                    FlatButton(
                      onPressed: () async {
                        var typedCityName = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CityScreen();
                        }));

                        print(typedCityName);
                        makeRequestAndUpdateUiWithCityName(typedCityName);
                      },
                      child: Icon(
                        Icons.location_city,
                        size: 30.0,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(24, 40, 24, 0),
                child: Row(
                  children: <Widget>[
                    Text('$mTemperature°' ?? 'No data', style: kTempTextStyle),
                    Text(
                      mWeatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(24, 40, 24, 0),
                child: Text(
                  '$mMessage in $mCityName' ?? 'No data',
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
