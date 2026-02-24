class Weather{
  final String cityName;
  final double temparature;
  final String mainCondition;
  final int humidity;
  final double windSpeed;
  final int pressure;

  Weather({
    required this.cityName,
    required this.temparature,
    required this.mainCondition,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
  });

  factory Weather.fromJson(Map<String, dynamic> json){
    return Weather(
      cityName: json['name'],
      temparature: json['main']['temp'].toDouble(), 
      mainCondition: json['weather'][0]['main'],
      humidity: json['main']['humidity']?.toInt() ?? 0,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      pressure: json['main']['pressure']?.toInt() ?? 0,
      );
  }
}