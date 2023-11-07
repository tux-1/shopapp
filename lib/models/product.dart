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

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final url = Uri.https(
      'shopapp-3f885-default-rtdb.europe-west1.firebasedatabase.app',
      '/userFavorites/$userId/$id.json',
      {'auth': token},
    );
    var oldFavorite = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      //for patch, put & delete http package won't throw an error if u remove .json
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldFavorite);
      }
    } catch (error) {
      _setFavValue(oldFavorite);
      throw HttpException('Could not favorite');
    }
  }
}
