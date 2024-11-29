import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
  LocationPermission? permission;

  Future<void> getPermission() async {
    permission = await geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permission
      permission = await geolocatorPlatform.requestPermission();
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
    final LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.low,
      distanceFilter: 1000,
    );
    Position position =
        await Geolocator.getCurrentPosition(locationSettings: locationSettings);
    print(position);
  }

  @override
  void initState() {
    // TODO: implement initState
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
