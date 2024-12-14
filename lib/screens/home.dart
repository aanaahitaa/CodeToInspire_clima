import 'package:climate/Components/loading_widget.dart';
import 'package:climate/services/networking.dart';
import 'package:climate/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:climate/services/location.dart';

import '../Components/details_widget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isDataLoaded = false;
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
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  @override
  Widget build(BuildContext context) {
    if (!isDataLoaded) {
      return const LoadingWidget();
    } else {
      return Scaffold(
        backgroundColor: kOverlayColor,
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextField(
                        decoration: kTextFieldDecoration,
                        onSubmitted: (String typedName) {
                          print(typedName);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white12,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Container(
                          height: 60,
                          child: Row(
                            children: const [
                              Text('My Location', style: kTextFieldTextStyle),
                              SizedBox(width: 8),
                              Icon(Icons.gps_fixed, color: Colors.white60),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_city, color: kMidLightColor),
                        SizedBox(width: 12),
                        Text(
                          'City Name',
                          style: kLocationTextStyle,
                        )
                      ],
                    ),
                    SizedBox(height: 25),
                    Icon(Icons.wb_sunny_outlined, size: 280),
                    SizedBox(height: 40),
                    Text('00°', style: kTempTextStyle),
                    Text('CLEAR SKY', style: kLocationTextStyle),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: kOverlayColor,
                  child: Container(
                    height: 90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DetailsWidget(
                          title: 'FEELS LIKE',
                          value: '31°',
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: VerticalDivider(thickness: 1),
                        ),
                        DetailsWidget(
                          title: 'HUMIDITY',
                          value: '15%',
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: VerticalDivider(thickness: 1),
                        ),
                        DetailsWidget(
                          title: 'WIND',
                          value: '7',
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}



// var id = decodedData['weather'][0]['id'];
// var temperature = decodedData['main']['temp'];
// var cityName = decodedData['name'];
