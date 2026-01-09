import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:provider/provider.dart";

import "../providers/post_provider.dart";
import "../providers/weather_provider.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _homeCityController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final weather = context.read<WeatherProvider>();
      if (weather.homeCity.isNotEmpty) {
        _homeCityController.text = weather.homeCity;
      }
    });
  }

  @override
  void dispose() {
    _homeCityController.dispose();
    super.dispose();
  }

  void _saveHomeCity(BuildContext context) {
    final weather = context.read<WeatherProvider>();
    weather.setHomeCity(_homeCityController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Ville enregistrée.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final posts = context.watch<PostProvider>();
    final weather = context.watch<WeatherProvider>();

    Widget apiStatus() {
      if (posts.state == LoadState.loading) {
        return const Row(
          children: [
            SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2)),
            SizedBox(width: 10),
            Expanded(
                child:
                    Text("Chargement des données depuis l’API open source...")),
          ],
        );
      }
      if (posts.state == LoadState.error) {
        return Text(posts.errorMessage ?? "Erreur inconnue");
      }
      if (posts.state == LoadState.success) {
        return Text("API OK — ${posts.posts.length} éléments récupérés.");
      }
      return const Text("API non lancée.");
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Accueil"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Présentation / choix techniques
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Présentation",
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    SizedBox(height: 8),
                    Text("Projet Flutter.\n"
                        "- Page Accueil : saisie de la ville de résidence (partage de données) + test de l'API\n"
                        "- Page Météo : Possibilité d'entrer un nom de ville et d'avoir des informations via openweathermap\n\n"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Ville de résidence (transfert de données)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Votre ville de résidence",
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _homeCityController,
                      decoration: const InputDecoration(
                        labelText: "Ville",
                        hintText: "ex : Marseille",
                        prefixIcon: Icon(Icons.home),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _saveHomeCity(context),
                            icon: const Icon(Icons.save),
                            label: const Text("Enregistrer"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (weather.homeCity.isNotEmpty)
                      Text("Ville enregistrée : ${weather.homeCity}"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Aller à la météo (pré-remplie)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // on enregistre avant de naviguer (si l'utilisateur a tapé sans cliquer sur Enregistrer)
                      context
                          .read<WeatherProvider>()
                          .setHomeCity(_homeCityController.text);
                      context.go("/weather");
                    },
                    icon: const Icon(Icons.cloud),
                    label: const Text("Voir la météo"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Démo API open source (sans afficher les posts)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("API open source (démonstration)",
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: posts.state == LoadState.loading
                                ? null
                                : () => posts.loadPosts(),
                            icon: const Icon(Icons.sync),
                            label: const Text("Tester / rafraîchir l’API"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    apiStatus(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
