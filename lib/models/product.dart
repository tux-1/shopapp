import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.price,
    required this.imageUrl,
    required this.id,
    required this.title,
    required this.description,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus() async {
    final url = Uri.https(
        'shopapp-3f885-default-rtdb.europe-west1.firebasedatabase.app',
        '/products/$id.json');

    isFavorite = !isFavorite;
    notifyListeners();
    try {
      await http.patch(url,
          body: json.encode({
            'isFavorite': isFavorite,
          }));
    } catch (error) {
      isFavorite = !isFavorite;
      notifyListeners();
      throw HttpException('Could not favorite');
    }
  }
}
