import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  // var _showFavoritesOnly = false;

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((item) => item.isFavorite == true).toList();
    // } else {
    return [..._items];

    //[..._items] because just items would return a pointer
    //instead of an address
  }

  Future<void> addProduct(Product product) {
    final url = Uri.https(
        //remove the 'https://' if you use the .https constructor
        //or use the .parse constructor if you wanna keep the https
        //also remove the '/' at the end of the link
        'shopapp-3f885-default-rtdb.europe-west1.firebasedatabase.app',
        '/products.json');
    return http //this is the future that'll, but it'll return its '.then()'
        .post(url,
            body: json.encode({
              // JSON = JavaScript Object Notation
              'title': product.title,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'price': product.price,
              'isFavorite': product.isFavorite,
            }))
        //if an error is caught here the next .then() will be skipped to the catch
        .then((response) {
      // print(json.decode(response.body));
      //returns the key of the object in database map
      //{name: -Ni0xX7xzdf3XqFVbx1d} for example
      final newProduct = Product(
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        title: product.title,
        id: json.decode(response.body)['name'],
      );
      //use the same id of the object in the database
      _items.add(newProduct);
      // _items.insert(0, newProduct); //to insert at the start of list
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  void updateProduct(String id, Product newProduct) {
    final productIndex = _items.indexWhere((element) => element.id == id);
    if (productIndex >= 0) {
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
