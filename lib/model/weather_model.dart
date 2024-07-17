class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final String datetime;
  final String sunRise;
  final String sunSet;
  final double maxTemp;
  final double minTemp;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.datetime,
    required this.sunRise,
    required this.sunSet,
    required this.maxTemp,
    required this.minTemp,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] ?? '',
      temperature: (json['main']['temp'] as num).toDouble(),
      mainCondition: json['weather'][0]['main'] ?? '',
      datetime: json['dt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000)
              .toIso8601String()
          : '',
      sunRise: json['sys']['sunrise'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['sys']['sunrise'] * 1000)
              .toIso8601String()
          : '',
      sunSet: json['sys']['sunset'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000)
              .toIso8601String()
          : '',
      maxTemp: (json['main']['temp_max'] as num).toDouble(),
      minTemp: (json['main']['temp_min'] as num).toDouble(),
    );
  }
}



