import "package:flutter/material.dart";
import "../models/post.dart";
import "../services/jsonplaceholder_service.dart";

enum LoadState { idle, loading, success, error }

class PostProvider extends ChangeNotifier {
  final JsonPlaceholderService _service = JsonPlaceholderService();

  LoadState state = LoadState.idle;
  String? errorMessage;
  List<Post> posts = [];
  Post? selected;

  Future<void> loadPosts() async {
    state = LoadState.loading;
    errorMessage = null;
    notifyListeners();

    try {
      posts = await _service.fetchPosts();
      state = LoadState.success;
    } catch (e) {
      state = LoadState.error;
      errorMessage = e.toString();
    }

    notifyListeners();
  }

  void select(Post p) {
    selected = p;
    notifyListeners();
  }

  void clearSelection() {
    selected = null;
    notifyListeners();
  }
}
