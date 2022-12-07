import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });
  void toggleFavorite(String token, String userId) async {
    final oldFavoritte = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        ('https://shopapp-2fcdd-default-rtdb.firebaseio.com/userfavorites/$userId/$id.json?auth=$token');

    final response = await http.put(url,
        body: json.encode(
          isFavorite,
        ));
    if (response.statusCode >= 400) {
      isFavorite = oldFavoritte;
      notifyListeners();
      print(response.statusCode);
      throw (response);
    }
  }
}
