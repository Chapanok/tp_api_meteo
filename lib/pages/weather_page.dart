import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:provider/provider.dart";
import "../providers/weather_provider.dart";

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    // on pré-remplit après le premier build pour pouvoir lire le provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<WeatherProvider>();
      final city = provider.prefilledCity;

      if (_controller.text.trim().isEmpty && city.isNotEmpty) {
        _controller.text = city;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Météo"),
        leading: IconButton(
          onPressed: () => context.go("/"),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Recherche météo (OpenWeatherMap)",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    if (provider.homeCity.isNotEmpty)
                      Text("Ville enregistrée : ${provider.homeCity}"),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (v) => provider.searchCity(v),
                      decoration: const InputDecoration(
                        labelText: "Ville",
                        hintText: "ex : Marseille",
                        prefixIcon: Icon(Icons.location_city),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: provider.state == WeatherState.loading
                                ? null
                                : () => provider.searchCity(_controller.text),
                            icon: const Icon(Icons.search),
                            label: const Text("Rechercher"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: provider.state == WeatherState.loading
                              ? null
                              : () {
                                  _controller.clear();
                                  provider.reset();
                                },
                          child: const Text("Réinitialiser"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (provider.state == WeatherState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.state == WeatherState.error) {
                    return Center(
                      child: Text(provider.errorMessage ?? "Erreur inconnue"),
                    );
                  }

                  if (provider.data == null) {
                    return const Center(
                      child: Text("Entre une ville pour afficher la météo."),
                    );
                  }

                  final w = provider.data!;
                  return ListView(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                w.city,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 6),
                              Text("Description : ${w.description}"),
                              const Divider(height: 24),
                              Text(
                                  "Température : ${w.temp.toStringAsFixed(1)}°C"),
                              const SizedBox(height: 8),
                              Text(
                                  "Ressenti : ${w.feelsLike.toStringAsFixed(1)}°C"),
                              const SizedBox(height: 8),
                              Text("Humidité : ${w.humidity}%"),
                              const SizedBox(height: 8),
                              Text(
                                  "Vent : ${w.windSpeed.toStringAsFixed(1)} m/s"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
