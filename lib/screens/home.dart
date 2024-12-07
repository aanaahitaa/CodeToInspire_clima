import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:climate/services/location.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  LocationPermission? permission;

  void getData() async{
    http.Response response = await http.get(Uri.parse("http://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=078c4f6b9c9b3dba5ed8c615f16b30f7"));
      if(response.statusCode == 200){
        String data = response.body;
        print(data);
      }else{
        print(response.statusCode);
      };
  }
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

    print('Latitude: ${location.latitude}');
    print('Longitude: ${location.longitude}');
  }

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  @override
  Widget build(BuildContext context) {
    getData();
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
