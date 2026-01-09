class WeatherData {
  final String city;
  final String description;
  final double temp;
  final double feelsLike;
  final int humidity;
  final double windSpeed;

  WeatherData({
    required this.city,
    required this.description,
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final main = (json["main"] as Map<String, dynamic>?);
    final weatherList = (json["weather"] as List<dynamic>?);
    final wind = (json["wind"] as Map<String, dynamic>?);

    final description = (weatherList != null && weatherList.isNotEmpty)
        ? ((weatherList.first as Map<String, dynamic>)["description"]
                  as String? ??
              "")
        : "";

    return WeatherData(
      city: (json["name"] as String?) ?? "",
      description: description,
      temp: ((main?["temp"] as num?) ?? 0).toDouble(),
      feelsLike: ((main?["feels_like"] as num?) ?? 0).toDouble(),
      humidity: ((main?["humidity"] as num?) ?? 0).toInt(),
      windSpeed: ((wind?["speed"] as num?) ?? 0).toDouble(),
    );
  }
}
