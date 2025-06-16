// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// const String apiKey = "8a592c4bde374f6c89f141002251106";
//
// class WeatherApiServices {
//   final String _baseUrl = "https://api.weatherapi.com/v1";
//   Future<Map<String, dynamic>> getHourlyForecast(String location) async {
//     final url =
//         Uri.parse("$_baseUrl/forecast.json?Key=$apiKey&q=$location&days=7");
//
//     final res = await http.get(url);
//     if (res.statusCode != 200) {
//       throw Exception("Failed to fetch data: ${res.body}");
//     }
//     final data = json.decode(res.body);
//     if (data.containKey('error')) {
//       throw Exception(data['error']['message'] ?? 'invalid location');
//     }
//     return data;
//   }
//
//   Future<List<Map<String, dynamic>>> getPastSevenDaysWeather(
//       String location) async {
//     final List<Map<String, dynamic>> pastWeather = [];
//     final today = DateTime.now();
//     for (int i = 1; i <= 7; i++) {
//       final data = today.subtract(Duration(days: i));
//       final formattedDate =
//           "${data.year}-${data.month.toString().padLeft(2, "0")}-${data.day.toString().padLeft(2, "0")}";
//
//       final url = Uri.parse(
//           "$_baseUrl/history.json?Key=$apiKey&q=$location&dt=$formattedDate");
//       final res = await http.get(url);
//       if (res.statusCode == 200) {
//         final data = json.decode(res.body);
//
//         if (data.containsKey('error')) {
//           throw Exception(data['error']['message'] ?? 'Invalid location');
//         }
//         if (data['forecast']?['forecastday'] != null) {
//           pastWeather.add(data);
//         }
//       } else {
//         debugPrint('Failed to fetch past data for $formattedDate: ${res.body}');
//       }
//     }
//     return pastWeather;
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String apiKey = "8a592c4bde374f6c89f141002251106";

class WeatherApiServices {
  final String _baseUrl = "https://api.weatherapi.com/v1";

  // Get current weather for a location
  Future<Map<String, dynamic>> getCurrentWeather(String location) async {
    final url = Uri.parse("$_baseUrl/current.json?key=$apiKey&q=$location");

    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception("Failed to fetch current weather: ${res.body}");
    }

    final data = json.decode(res.body);
    if (data.containsKey('error')) {
      throw Exception(data['error']['message'] ?? 'Invalid location');
    }

    return data;
  }

  // Get 7-day forecast
  Future<Map<String, dynamic>> getHourlyForecast(String location) async {
    final url =
    Uri.parse("$_baseUrl/forecast.json?key=$apiKey&q=$location&days=7");

    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception("Failed to fetch forecast: ${res.body}");
    }

    final data = json.decode(res.body);
    if (data.containsKey('error')) {
      throw Exception(data['error']['message'] ?? 'Invalid location');
    }

    return data;
  }

  // Get past 7 days weather data
  Future<List<Map<String, dynamic>>> getPastSevenDaysWeather(String location) async {
    final List<Map<String, dynamic>> pastWeather = [];
    final today = DateTime.now();

    for (int i = 1; i <= 7; i++) {
      final date = today.subtract(Duration(days: i));
      final formattedDate =
          "${date.year}-${date.month.toString().padLeft(2, "0")}-${date.day.toString().padLeft(2, "0")}";

      final url = Uri.parse(
          "$_baseUrl/history.json?key=$apiKey&q=$location&dt=$formattedDate");

      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        if (data.containsKey('error')) {
          debugPrint('Error in history data: ${data['error']['message']}');
        } else if (data['forecast']?['forecastday'] != null) {
          pastWeather.add(data);
        }
      } else {
        debugPrint('Failed to fetch data for $formattedDate: ${res.body}');
      }
    }
    return pastWeather;
  }
}


