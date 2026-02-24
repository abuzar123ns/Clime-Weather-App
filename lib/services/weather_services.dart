import 'dart:convert';

import 'package:app_three/models/forecast_model.dart';
import 'package:app_three/models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class WeatherService {
  static const String _baseWeather =
      'https://api.openweathermap.org/data/2.5/weather';
  static const String _baseForecast =
      'https://api.openweathermap.org/data/2.5/forecast';

  final String apiKey;

  WeatherService(this.apiKey);

  // ---------------- GET WEATHER BY CITY ----------------
  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(
      Uri.parse('$_baseWeather?q=${Uri.encodeComponent(cityName)}&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // ---------------- GET 5-DAY FORECAST BY CITY ----------------
  Future<List<ForecastDay>> getForecast(String cityName) async {
    final response = await http.get(
      Uri.parse('$_baseForecast?q=${Uri.encodeComponent(cityName)}&appid=$apiKey&units=metric'),
    );

    if (response.statusCode != 200) throw Exception('Failed to load forecast');

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final list = data['list'] as List<dynamic>? ?? [];
    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    int? lastDay;
    final days = <ForecastDay>[];
    for (final e in list) {
      final map = e as Map<String, dynamic>;
      final dt = map['dt'] as int;
      final date = DateTime.fromMillisecondsSinceEpoch(dt * 1000);
      final dayStart = DateTime(date.year, date.month, date.day);
      final dayOfYear = dayStart.difference(today).inDays;
      if (lastDay != null && dayOfYear == lastDay) continue;
      lastDay = dayOfYear;

      final main = map['main'] as Map<String, dynamic>?;
      final temp = (main?['temp'] as num?)?.toDouble() ?? 0.0;
      final weatherList = map['weather'] as List<dynamic>?;
      final mainCondition = weatherList != null && weatherList.isNotEmpty
          ? (weatherList[0] as Map<String, dynamic>)['main'] as String? ?? 'Clear'
          : 'Clear';

      String dayLabel;
      if (dayOfYear == 0) {
        dayLabel = 'Today';
      } else if (dayOfYear == 1) {
        dayLabel = 'Tomorrow';
      } else {
        dayLabel = dayNames[date.weekday - 1];
      }

      days.add(ForecastDay(
        dayName: dayLabel,
        mainCondition: mainCondition,
        temp: temp,
      ));
      if (days.length >= 5) break;
    }
    return days;
  }

  // ---------------- GET CURRENT CITY ----------------
  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    return placemarks.first.locality ?? "";
  }
}
