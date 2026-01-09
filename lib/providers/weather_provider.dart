import "package:flutter/material.dart";
import "../models/weather_data.dart";
import "../services/openweather_service.dart";

enum WeatherState { idle, loading, success, error }

class WeatherProvider extends ChangeNotifier {
  final OpenWeatherService _service = OpenWeatherService();

  WeatherState state = WeatherState.idle;
  String? errorMessage;

  WeatherData? data;

  // ville saisie sur la page d'accueil
  String homeCity = "";

  // dernière recherche effectuée
  String lastCity = "";

  void setHomeCity(String city) {
    homeCity = city.trim();
    notifyListeners();
  }

  String get prefilledCity {
    if (homeCity.isNotEmpty) return homeCity;
    return lastCity;
  }

  Future<void> searchCity(String city) async {
    final clean = city.trim();
    if (clean.isEmpty) return;

    lastCity = clean;
    state = WeatherState.loading;
    errorMessage = null;
    notifyListeners();

    try {
      data = await _service.fetchByCity(clean);
      state = WeatherState.success;
    } catch (e) {
      state = WeatherState.error;
      errorMessage = e.toString();
    }

    notifyListeners();
  }

  void reset() {
    state = WeatherState.idle;
    errorMessage = null;
    data = null;
    lastCity = "";
    notifyListeners();
  }
}
