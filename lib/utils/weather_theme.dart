import 'package:flutter/material.dart';

/// Returns gradient colors and text/icon color for the current weather and time.
class WeatherTheme {
  final List<Color> gradientColors;
  final Color textColor;
  final Color secondaryColor;

  const WeatherTheme({
    required this.gradientColors,
    required this.textColor,
    required this.secondaryColor,
  });

  LinearGradient get gradient => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: gradientColors,
      );

  static bool get _isNight {
    final hour = DateTime.now().hour;
    return hour < 6 || hour >= 18;
  }

  static WeatherTheme fromCondition(String? mainCondition) {
    final condition = (mainCondition ?? 'Clear').toLowerCase();
    final isNight = _isNight;

    if (isNight) {
      if (condition.contains('clear')) {
        return const WeatherTheme(
          gradientColors: [
            Color(0xFF0F0C29),
            Color(0xFF302B63),
            Color(0xFF24243E),
          ],
          textColor: Color(0xFFE8E6F0),
          secondaryColor: Color(0xFFB8B5D0),
        );
      }
      if (condition.contains('rain') || condition.contains('drizzle') || condition.contains('thunderstorm')) {
        return const WeatherTheme(
          gradientColors: [
            Color(0xFF1A1A2E),
            Color(0xFF16213E),
            Color(0xFF0F3460),
          ],
          textColor: Color(0xFFE8E8E8),
          secondaryColor: Color(0xFFA0AEC0),
        );
      }
      return const WeatherTheme(
        gradientColors: [
          Color(0xFF1E1E2E),
          Color(0xFF2D2D44),
          Color(0xFF252536),
        ],
        textColor: Color(0xFFE8E6F0),
        secondaryColor: Color(0xFFB8B5D0),
      );
    }

    // Day themes
    if (condition.contains('clear')) {
      return const WeatherTheme(
        gradientColors: [
          Color(0xFF56CCF2),
          Color(0xFF2F80ED),
          Color(0xFF2196F3),
        ],
        textColor: Color(0xFF1A237E),
        secondaryColor: Color(0xFF3949AB),
      );
    }
    if (condition.contains('rain') || condition.contains('drizzle') || condition.contains('thunderstorm')) {
      return const WeatherTheme(
        gradientColors: [
          Color(0xFF4A5568),
          Color(0xFF2D3748),
          Color(0xFF1A202C),
        ],
        textColor: Color(0xFFE2E8F0),
        secondaryColor: Color(0xFFA0AEC0),
      );
    }
    if (condition.contains('cloud') || condition.contains('mist') || condition.contains('fog') ||
        condition.contains('smoke') || condition.contains('dust')) {
      return const WeatherTheme(
        gradientColors: [
          Color(0xFF718096),
          Color(0xFF4A5568),
          Color(0xFF2D3748),
        ],
        textColor: Color(0xFFE2E8F0),
        secondaryColor: Color(0xFFCBD5E0),
      );
    }

    return const WeatherTheme(
      gradientColors: [
        Color(0xFF56CCF2),
        Color(0xFF2F80ED),
      ],
      textColor: Color(0xFF1A237E),
      secondaryColor: Color(0xFF3949AB),
    );
  }
}
