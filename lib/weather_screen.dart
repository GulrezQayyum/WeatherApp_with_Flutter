import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project/API.dart';
import 'dart:ui';
import 'package:flutter_project/HourlyForecast.dart';
import 'package:flutter_project/AdditionalInfo.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Moscow';
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$openWeatherAPIKey&units=metric'),
      );

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        throw 'Failed to load weather data';
      }
    } catch (e) {
      throw 'Error: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          final double currentTemp = currentWeatherData['main']['temp'];
          final String currentSky = currentWeatherData['weather'][0]['main'];

          final List<dynamic> forecastList = data['list'].sublist(0, 6);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 155, 61, 199), // Dark background like in the image
                    borderRadius: BorderRadius.circular(16), // Rounded edges
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3), // Shadow effect
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20), // Inner spacing
                  child: Column(
                    children: [
                      Text(
                        '${currentTemp.toStringAsFixed(1)}°C',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Text color
                        ),
                      ),
                      const SizedBox(height: 12),
                      Icon(
                        currentSky == 'Clouds'
                            ? Icons.cloud
                            : currentSky == 'Rain'
                                ? Icons.cloudy_snowing
                                : Icons.wb_sunny,
                        size: 64,
                        color: Colors.white, // Icon color
                      ),
                      const SizedBox(height: 14),
                      Text(
                        currentSky,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Weather Forecast',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: forecastList.map((forecast) {
                      final time = forecast['dt_txt'].substring(11, 16);
                      final temp = forecast['main']['temp'];
                      final sky = forecast['weather'][0]['main'];
                      IconData icon = Icons.wb_sunny;
                      if (sky == 'Clouds') {
                        icon = Icons.cloud;
                      } else if (sky == 'Rain') {
                        icon = Icons.cloudy_snowing;
                      }
                      return HourlyForecastItem(
                        time: time,
                        icon: icon,
                        temperature: '${temp.toStringAsFixed(1)}°C',
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfo(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: '${currentWeatherData['main']['humidity']}%',
                    ),
                    AdditionalInfo(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value:
                          '${currentWeatherData['wind']['speed'].toStringAsFixed(1)} m/s',
                    ),
                    AdditionalInfo(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: '${currentWeatherData['main']['pressure']} hPa',
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
