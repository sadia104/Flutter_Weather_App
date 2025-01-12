import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'weather_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WeatherProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WeatherScreen extends StatelessWidget {
  final TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final weatherData = weatherProvider.weatherData;

    // Get screen size for responsiveness
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
        child: Column(
          children: [
            // City input field
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Enter city name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // Responsive spacing

            // Search Button
            ElevatedButton(
              onPressed: () {
                String cityName = _cityController.text.trim();
                if (cityName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a city name!')),
                  );
                } else {
                  weatherProvider.fetchWeatherData(cityName);
                }
              },
              child: Text('Search'),
            ),
            SizedBox(height: screenHeight * 0.03), // Responsive spacing

            // Weather Data or Loading Indicator
            weatherProvider.isLoading
                ? CircularProgressIndicator()
                : weatherData != null && !weatherData.containsKey('error')
                ? Card(
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'City: ${weatherData['name']}',
                      style: TextStyle(fontSize: screenHeight * 0.025),
                    ),
                    Text(
                      'Temperature: ${weatherData['main']['temp']}°C',
                      style: TextStyle(fontSize: screenHeight * 0.02),
                    ),

                    // Display condition with icon in Row
                    Row(
                      children: [
                        _getWeatherIcon(weatherData['weather'][0]['description']),
                        SizedBox(width: screenWidth * 0.02), // Responsive spacing
                        Text(
                          'Condition: ${weatherData['weather'][0]['description']}',
                          style: TextStyle(fontSize: screenHeight * 0.02),
                        ),
                      ],
                    ),

                    Text(
                      'Humidity: ${weatherData['main']['humidity']}%',
                      style: TextStyle(fontSize: screenHeight * 0.02),
                    ),
                  ],
                ),
              ),
            )
                : Text(weatherData?['error'] ?? 'Enter a city name to get weather data.'),
          ],
        ),
      ),
    );
  }

  Widget _getWeatherIcon(String condition) {
    if (condition.contains("clear")) {
      return Icon(FontAwesomeIcons.sun, size: 40, color: Colors.yellow);
    } else if (condition.contains("clouds")) {
      return Icon(FontAwesomeIcons.cloud, size: 40, color: Colors.grey);
    } else if (condition.contains("haze")) {
      return Icon(FontAwesomeIcons.cloud, size: 40, color: Colors.black26);
    } else if (condition.contains("rain")) {
      return Icon(FontAwesomeIcons.cloudShowersHeavy, size: 40, color: Colors.blue);
    } else if (condition.contains("snow")) {
      return Icon(FontAwesomeIcons.snowflake, size: 40, color: Colors.white);
    } else {
      return Icon(FontAwesomeIcons.smile, size: 40, color: Colors.green);
    }
  }
}
