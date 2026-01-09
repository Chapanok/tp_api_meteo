import "dart:convert";
import "package:http/http.dart" as http;
import "../models/post.dart";

class JsonPlaceholderService {
  static const String _host = "jsonplaceholder.typicode.com";

  Future<List<Post>> fetchPosts() async {
    final uri = Uri.https(_host, "/posts");
    final res = await http.get(uri);

    if (res.statusCode != 200) {
      throw Exception("Erreur API open source (${res.statusCode})");
    }

    final data = jsonDecode(res.body) as List<dynamic>;
    return data.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
  }
}
