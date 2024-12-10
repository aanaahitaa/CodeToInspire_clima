import 'package:climate/services/networking.dart';
import 'package:climate/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:climate/services/location.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double? latitude, longitude;
  GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
  LocationPermission? permission;

  Future<void> getPermission() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.denied) {
        if (permission == LocationPermission.deniedForever) {
          print(
              'Permission permanently denied, please provide permission from your settings.');
        } else {
          print('Permission granted');
          getLocation();
        }
      } else {
        print('User Denied permission');
      }
    } else {
      getLocation();
    }
  }

  Future<void> getLocation() async {
    Location location = Location();
    await location.getCurrentLocation();

    latitude = location.latitude;
    longitude = location.longitude;
    NetworkHelper networkHelper = NetworkHelper(
        "http://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey");
    var weatherData = await networkHelper.getData();
  }

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              getLocation();
            },
            child: const Text(
              'Get Location',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}



// var id = decodedData['weather'][0]['id'];
// var temperature = decodedData['main']['temp'];
// var cityName = decodedData['name'];