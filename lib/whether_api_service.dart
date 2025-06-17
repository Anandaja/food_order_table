// import 'package:geolocator/geolocator.dart';

import 'dart:convert';
import 'package:flutter/foundation.dart';
import "package:http/http.dart" as http;

String apiKey = '1e34f45e5779b1134b8f9a4a76cb5787';

const weatherApiUrl = 'https://api.openweathermap.org/data/2.5/weather';

String place = 'Marayoor';

class Location {
  double? latitude;
  double? longitide;
  // String apiKey = '1e34f45e5779b1134b8f9a4a76cb5787';
  int? status;

  /// async and await are used for time consuming tasks
  /// Get your current loatitude and longitude
  /// Location accuracy depends on the type of app high,low ,
  /// high accuracy also result in more power consumed
  Future<void> getCurrentLocation() async {
    try {
      var url = //just added q=kochi here
          'http://api.openweathermap.org/geo/1.0/direct?q=$place&limit=5&appid=1e34f45e5779b1134b8f9a4a76cb5787';

      final response = await http.get(Uri.parse(url));
      if (kDebugMode) {
        print("Response $response");
      }
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("Amm");
        }
        final List decodedJson = json.decode(response.body);
        // final weatherData = json.decode(response.body);
        // print("objj ${decodedJson[0]['lat']}");
        latitude = decodedJson[0]['lat'];
        longitide = decodedJson[0]['lon'];

        if (kDebugMode) {
          print(
              "Latituede $latitude & longttude $longitide of ${decodedJson[0]['name']}");
        }

        // return Location.fromMap(weatherData);
      } else {
        if (kDebugMode) {
          print("error on status code checking");
        }
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error on function catch $e");
      }
      throw Exception('Failed to load weather data');
    }
  }
}

/// weather API network helper
/// pass the weatherAPI url
///  to this class to get geographical coordinates
class NetworkData {
  NetworkData(this.url);
  final String url;

  /// get geographical coordinates from open weather API call
  Future getData() async {
    http.Response response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print("URL $url");
    } //it prints the url with wether data
    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      if (kDebugMode) {
        print(response.statusCode);
      }
    }
  }
}

class WeatherModel {
  Future<dynamic> getLocationWeather() async {
    try {
      /// await for methods that return future
      Location location = Location();
      await location.getCurrentLocation();

      /// Get location data
      ///&units=metric change the temperature metric
      NetworkData networkHelper = NetworkData(
          '$weatherApiUrl?lat=${location.latitude}&lon=${location.longitide}&appid=$apiKey&units=metric');

      var weatherData = await networkHelper.getData();
      return weatherData;
    } catch (e) {
      //return some bool on each  error block and show no whether when network lows or any other problem
      if (kDebugMode) {
        print("Error on getLocatiowether function $e");
      }
    }
  }

  /// add appropriete icon to page  according to response from API
  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  int cold_threshold = 23;
  int warm_threshold = 30;
  int hot_threshold = 40;

  String coldAnimation = 'assets/animations/cold whether.json';
  String warmAnimation = 'assets/animations/warm whther.json';
  String HotAnimation = 'assets/animations/hot whether.json';

  String ShowAsset(int temprature) {
    if (temprature <= cold_threshold) {
      print("Cold");
      // return cold gif
      return coldAnimation;
    } else if (temprature <= warm_threshold) {
      print("Warm");
      //return warm gif
      return warmAnimation;
    } else {
      // return hot gif
      print("Hot");
      return HotAnimation;
    }
  }
}
