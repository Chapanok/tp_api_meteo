import "dart:convert";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:http/http.dart" as http;

import "../models/weather_data.dart";

class OpenWeatherService {
  static const String _host = "api.openweathermap.org";

  String get _apiKey => (dotenv.env["OPENWEATHER_API_KEY"] ?? "").trim();

  Future<WeatherData> fetchByCity(String city) async {
    if (_apiKey.isEmpty) {
      throw Exception("Clé OpenWeatherMap manquante (OPENWEATHER_API_KEY).");
    }

    final uri = Uri.https(_host, "/data/2.5/weather", {
      "q": city,
      "appid": _apiKey,
      "units": "metric",
      "lang": "fr",
    });

    final res = await http.get(uri);

    if (res.statusCode == 404) {
      throw Exception("Ville introuvable.");
    }
    if (res.statusCode != 200) {
      throw Exception("Erreur météo (${res.statusCode})");
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return WeatherData.fromJson(json);
  }
}
