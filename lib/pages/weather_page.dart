import 'package:app_three/data/cities.dart';
import 'package:app_three/models/forecast_model.dart';
import 'package:app_three/models/weather_model.dart';
import 'package:app_three/services/weather_services.dart';
import 'package:app_three/utils/weather_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('0220a74a3a0450468ce1a7907ab117f2');
  final _searchController = TextEditingController();

  Weather? _weather;
  List<ForecastDay> _forecast = [];
  bool _isLoading = false;

  Future<void> _fetchWeather({String? city}) async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      String cityName = city?.trim() ?? '';
      if (cityName.isEmpty) {
        cityName = await _weatherService.getCurrentCity();
        if (cityName.isEmpty) throw Exception('Could not get current location');
      }

      final results = await Future.wait([
        _weatherService.getWeather(cityName),
        _weatherService.getForecast(cityName),
      ]);
      final weather = results[0] as Weather;
      final forecast = results[1] as List<ForecastDay>;

      if (!mounted) return;
      setState(() {
        _weather = weather;
        _forecast = forecast;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('City not found'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _onRefresh() async {
    final city = _weather?.cityName;
    await _fetchWeather(city: city);
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  IconData _forecastIcon(String mainCondition) {
    switch (mainCondition.toLowerCase()) {
      case 'rain':
      case 'drizzle':
        return Icons.water_drop_outlined;
      case 'thunderstorm':
        return Icons.flash_on_outlined;
      case 'clouds':
      case 'mist':
      case 'fog':
        return Icons.cloud_outlined;
      case 'clear':
        return Icons.wb_sunny_outlined;
      default:
        return Icons.wb_cloudy_outlined;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = WeatherTheme.fromCondition(_weather?.mainCondition);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: theme.gradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TypeAheadField<String>(
                        controller: _searchController,
                        builder: (context, controller, focusNode) {
                          return Container(
                            decoration: BoxDecoration(
                              color: theme.textColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: controller,
                              focusNode: focusNode,
                              style: TextStyle(
                                color: theme.textColor,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search city...',
                                hintStyle: TextStyle(
                                  color: theme.textColor.withValues(alpha: 0.6),
                                ),
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  color: theme.secondaryColor,
                                  size: 22,
                                ),
                                filled: true,
                                fillColor: Colors.transparent,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          );
                        },
                        suggestionsCallback: (pattern) {
                          if (pattern.length < 2) return [];
                          final lower = pattern.toLowerCase();
                          return kMajorCities
                              .where((c) => c.toLowerCase().contains(lower))
                              .take(8)
                              .toList();
                        },
                        decorationBuilder: (context, child) {
                          return Material(
                            elevation: 8,
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xFF1E1E2E),
                            child: child,
                          );
                        },
                        itemBuilder: (context, city) => ListTile(
                          leading: Icon(
                            Icons.location_city,
                            color: Colors.grey[400],
                            size: 22,
                          ),
                          title: Text(
                            city,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        emptyBuilder: (context) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: Text(
                              'No cities found',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        onSelected: (city) {
                          _searchController.text = city;
                          _fetchWeather(city: city);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Material(
                      color: theme.textColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      child: IconButton(
                        onPressed: _isLoading ? null : () => _fetchWeather(),
                        icon: Icon(
                          Icons.my_location_rounded,
                          color: theme.textColor,
                          size: 24,
                        ),
                        tooltip: 'Current Location',
                      ),
                    ),
                  ],
                ),
              ),
              if (_isLoading && _weather == null)
                Expanded(child: _buildShimmerLoading(theme))
              else
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    color: theme.textColor,
                    backgroundColor: theme.secondaryColor.withValues(alpha: 0.3),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height -
                              MediaQuery.of(context).padding.top -
                              MediaQuery.of(context).padding.bottom -
                              80,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: theme.secondaryColor,
                                  size: 28,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _weather?.cityName ?? '—',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: theme.textColor,
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                            Lottie.asset(
                              getWeatherAnimation(_weather?.mainCondition),
                            ),
                            Text(
                              _weather != null
                                  ? '${_weather!.temparature.round()} °C'
                                  : '— °C',
                              style: TextStyle(
                                color: theme.textColor,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (_weather != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _metricChip(
                                      theme,
                                      Icons.water_drop,
                                      '${_weather!.humidity}%',
                                      'Humidity',
                                    ),
                                    _metricChip(
                                      theme,
                                      Icons.air,
                                      '${_weather!.windSpeed.toStringAsFixed(1)} m/s',
                                      'Wind',
                                    ),
                                    _metricChip(
                                      theme,
                                      Icons.speed,
                                      '${_weather!.pressure} hPa',
                                      'Pressure',
                                    ),
                                  ],
                                ),
                              ),
                            if (_forecast.isNotEmpty) _buildForecastList(theme),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForecastList(WeatherTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Text(
            '5-day forecast',
            style: TextStyle(
              color: theme.textColor.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _forecast.length,
            itemBuilder: (context, index) {
              final day = _forecast[index];
              return Container(
                width: 88,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: theme.textColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day.dayName,
                      style: TextStyle(
                        color: theme.secondaryColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Icon(
                      _forecastIcon(day.mainCondition),
                      color: theme.textColor,
                      size: 28,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${day.temp.round()}°',
                      style: TextStyle(
                        color: theme.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildShimmerLoading(WeatherTheme theme) {
    return Shimmer.fromColors(
      baseColor: theme.textColor.withValues(alpha: 0.2),
      highlightColor: theme.textColor.withValues(alpha: 0.35),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 140,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(80),
              ),
            ),
            Container(
              width: 120,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                3,
                (_) => Column(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 56,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricChip(WeatherTheme theme, IconData icon, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: theme.secondaryColor, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: theme.textColor,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: theme.textColor.withValues(alpha: 0.7),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
