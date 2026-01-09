import "package:go_router/go_router.dart";
import "../pages/home_page.dart";
import "../pages/weather_page.dart";

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(path: "/", builder: (context, state) => const HomePage()),
      GoRoute(
        path: "/weather",
        builder: (context, state) => const WeatherPage(),
      ),
    ],
  );
}
