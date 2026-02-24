# Weather App (FLutter)

A beautiful Flutter weather application that displays real-time weather information based on your current location. The app features animated weather conditions using Lottie animations and fetches live weather data from OpenWeatherMap API.

![App Marketting](https://github.com/user-attachments/assets/cc1c6c3c-a1bb-4ad1-9ba3-6bb6312efec1)

## Features

-  **Auto-location detection** - Automatically detects your current city using GPS
-  **Real-time weather data** - Displays current temperature in Celsius
-  **Animated weather conditions** - Beautiful Lottie animations for different weather states:
  -  Clear/Sunny
  -  Clouds/Mist/Fog/Smoke/Dust
  -  Rain/Drizzle
  -  Thunderstorm
-  **Clean UI** - Minimal, dark-themed interface for easy viewing


The app displays:
- Current city name with location icon
- Animated weather condition
- Temperature in Celsius

## Tech Stack

- **Flutter** - Cross-platform mobile framework
- **Dart** - Programming language
- **OpenWeatherMap API** - Weather data provider
- **Geolocator** - Location services
- **Geocoding** - Convert coordinates to city names
- **Lottie** - Smooth animations
- **HTTP** - API calls

## Prerequisites

Before running this app, ensure you have:

- Flutter SDK (3.10.7 or higher) installed
- Dart SDK
- Android Studio / Xcode (for Android/iOS development)
- A code editor (VS Code, Android Studio, or IntelliJ)
- An active internet connection
- **OpenWeatherMap API key** (see setup instructions below)

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/MohammedMeraj/Weather-App-Flutter.git
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Get Your OpenWeatherMap API Key

1. Go to [OpenWeatherMap](https://openweathermap.org/)
2. Sign up for a free account
3. Navigate to **API Keys** section in your account
4. Generate a new API key (or use the default one provided)
5. Copy your API key

### 4. Configure API Key

**⚠️ IMPORTANT:** You need to replace the API key in the code with your own key.

1. Open the file: `lib/pages/weather_page.dart`
2. Find line 16 where the API key is defined:
   ```dart
   final _WeatherService = WeatherService('API_KEY');
   ```
3. Replace `'API_KEY'` with your own API key:
   ```dart
   final _WeatherService = WeatherService('YOUR_API_KEY_HERE');
   ```

**Security Note:** For production apps, store API keys securely using environment variables or secure storage packages like `flutter_dotenv`.

### 5. Platform-Specific Configuration

#### Android

Add the following permissions to `android/app/src/main/AndroidManifest.xml` inside the `<manifest>` tag:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

#### iOS

Add the following to `ios/Runner/Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location to show weather for your current city.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to location to show weather for your current city.</string>
```

### 6. Run the App

#### On Android/iOS Device or Emulator

```bash
flutter run
```

#### On Specific Device

```bash
# List all devices
flutter devices

# Run on specific device
flutter run -d <device-id>
```

#### On Chrome (Web)

```bash
flutter run -d chrome
```

## Project Structure

```
app_three/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── models/
│   │   └── weather_model.dart       # Weather data model
│   ├── pages/
│   │   └── weather_page.dart        # Main weather UI page
│   └── services/
│       └── weather_services.dart    # API service & location logic
├── assets/
│   ├── cloud.json                   # Cloudy weather animation
│   ├── rain.json                    # Rain weather animation
│   ├── sunny.json                   # Sunny weather animation
│   └── thunder.json                 # Thunderstorm animation
├── android/                         # Android-specific files
├── ios/                             # iOS-specific files
├── web/                             # Web-specific files
└── pubspec.yaml                     # Dependencies configuration
```

## Dependencies

The app uses the following Flutter packages:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  http: ^1.6.0                       # HTTP requests
  geolocator: ^14.0.2                # Location services
  geocoding: ^4.0.0                  # Reverse geocoding
  lottie: ^3.3.2                     # Animations

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_launcher_icons: ^0.13.1
  flutter_lints: ^6.0.0
```

## How It Works

1. **App Launch**: When the app starts, it requests location permission
2. **Location Detection**: Uses Geolocator to get current GPS coordinates
3. **City Name**: Converts coordinates to city name using Geocoding
4. **API Call**: Fetches weather data from OpenWeatherMap API for the detected city
5. **Display**: Shows city name, temperature, and animated weather condition
6. **Animation**: Displays appropriate Lottie animation based on weather condition

## Troubleshooting

### Location Permission Issues

- **Android**: Make sure location permissions are added to AndroidManifest.xml
- **iOS**: Ensure Info.plist has location usage descriptions
- Check device location settings are enabled

### API Errors

- Verify your API key is correct and active
- Check internet connection
- Ensure API key has not exceeded free tier limits (60 calls/minute, 1,000,000 calls/month)

### Build Errors

```bash
# Clean build
flutter clean

# Get dependencies again
flutter pub get

# Rebuild
flutter run
```

### Asset Loading Issues

Ensure `assets/` folder contains all required animation files:
- cloud.json
- rain.json
- sunny.json
- thunder.json

## Future Enhancements

Potential features to add:
- [ ] 5-day weather forecast
- [ ] Manual city search
- [ ] Multiple location support
- [ ] Weather notifications
- [ ] Dark/Light theme toggle
- [ ] More weather details (humidity, wind speed, pressure)
- [ ] Unit conversion (Celsius/Fahrenheit)

## License

This project is open-source and available for educational purposes.

## API Credits

Weather data provided by [OpenWeatherMap](https://openweathermap.org/)

## Support

For issues or questions:
1. Check existing issues
2. Review the troubleshooting section
3. Create a new issue with details about your problem

---

**Built with ❤️ using Flutter**
