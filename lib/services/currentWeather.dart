import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weatherModel.dart';

class CurrentWeatherPage extends StatefulWidget {
  const CurrentWeatherPage({Key? key}) : super(key: key);

  @override
  State<CurrentWeatherPage> createState() => _CurrentWeatherPageState();
}



class _CurrentWeatherPageState extends State<CurrentWeatherPage> {

   double latitude =0.0;
   double longitude=0.0;

  Future<Position> _getCurrentLocation() async{
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      return Future.error('Location Services Disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission  = await Geolocator.requestPermission();
      if(permission==LocationPermission.denied){
        return Future.error('Location Permissions are denied');
      }
    }
    if(permission == LocationPermission.deniedForever){
      return Future.error('Location Permissions are denied forever');
    }

    return await Geolocator.getCurrentPosition();

  }
  @override
  void initState() {

    super.initState();
    //calling the location function
    _getCurrentLocation().then((value) {
      latitude = value.latitude ;
      longitude = value.longitude ;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather Today"),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              // refreshing
              getCurrentWeather(latitude,longitude);
            },
          )
        ],
      ),
      body: Center(
        child: FutureBuilder(
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return weatherBox(snapshot.data);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return const CircularProgressIndicator();
            }
          },
          future: getCurrentWeather(latitude,longitude),
        ),
      ),
    );
  }

  Widget weatherBox(Weather _weather) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Container(
          margin: const EdgeInsets.all(5.0), child: const Text('Have a Nice day',style: TextStyle(fontSize: 20),)),
      Container(
          margin: const EdgeInsets.all(10.0),
          child: Text(
            "${_weather.temp}°C",
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 55),
          )),
      Container(
          margin: const EdgeInsets.all(5.0), child: Text(_weather.description)),
      Container(
          margin: const EdgeInsets.all(5.0),
          child: Text("Feels:${_weather.feelsLike}°C")),
      Container(
          margin: const EdgeInsets.all(5.0),
          child: Text("H:${_weather.high}°C L:${_weather.low}°C")),
      const SizedBox(height: 20,),
      Container(
          margin: const EdgeInsets.all(5.0),
          child: const Text("Tap the refresh button in AppBar to Refresh")),
    ]);
  }

  Future getCurrentWeather(double lat , double lon) async {

    // if(lat==null || lon==null){
    //   lat = 30.2;
    //   lon =76.0;
    //
    // }
    Weather weather;
    //String city = 'patiala';
    String apiKey = '82bd79e7d9e1373bcab9c2371d40b132';
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      weather = Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
    return weather;
  }
}
