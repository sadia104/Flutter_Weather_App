import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherProvider extends ChangeNotifier {
  Map<String, dynamic>? weatherData;
  bool isLoading = false;

  Future<void> fetchWeatherData(String cityName) async {
    final apiKey = '4e6947b3328a98022be115888e135c9b';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&units=metric&appid=4e6947b3328a98022be115888e135c9b';

    try {
      isLoading = true;
      notifyListeners();

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        weatherData = json.decode(response.body);
      } else {
        weatherData = {'error': 'City not found'};
      }
    } catch (error) {
      weatherData = {'error': 'Failed to fetch weather data'};
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
