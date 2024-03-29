import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/exceptions.dart';
import '../models/product.dart';

class Products with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String authToken;
  final String userId;

  Products(
    this.authToken,
    this.userId,
    this._items,
  );

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  List<Product> get items {
    return [..._items];
    //[..._items] because just items would return a pointer
    //instead of an address
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final Map<String, dynamic> queryParameters = filterByUser
        ? {
            'auth': authToken,
            'orderBy': '"creatorId"',
            'equalTo': '"$userId"',
          }
        : {
            'auth': authToken,
          };

    final url = Uri.https(
      'shopapp-3f885-default-rtdb.europe-west1.firebasedatabase.app',
      '/products.json', // encodedPath, the directory
      // THE AUTH TOKEN GOES IN queryParameters
      queryParameters,
    );

    //add ?auth=$authToken at the end of the link to access by using token
    //it's not working with me lol
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        //check if we have no data before using .forEach() on extractedData
        return;
      }
      //getting favorites data
      final favoritesUrl = Uri.https(
        'shopapp-3f885-default-rtdb.europe-west1.firebasedatabase.app',
        '/userFavorites/$userId.json',
        {
          'auth': authToken,
        },
      );

      final favoriteResponse = await http.get(favoritesUrl);
      final favoritesData =
          json.decode(favoriteResponse.body) as Map<String, dynamic>?;
      final List<Product> loadedProducts = [];
      extractedData.forEach((key, productData) {
        loadedProducts.add(Product(
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          id: key,
          title: productData['title'],
          description: productData['description'],
          isFavorite:
              favoritesData == null ? false : favoritesData[key] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    //putting async wrapped the function body in a future and but also made the
    //funciton body run somewhat in sync? (not sure of this part yet)

    final url = Uri.https(
      //remove the 'https://' if you use the .https constructor
      //or use the .parse constructor if you wanna keep the https
      //also remove the '/' at the end of the link
      'shopapp-3f885-default-rtdb.europe-west1.firebasedatabase.app',
      '/products.json',
      {'auth': authToken},
    ); //removing .json will yield an error
    try {
      final response =
          await http //this is the future that'll return, but it'll return its '.then()'
              .post(
        url,
        body: json.encode({
          // JSON = JavaScript Object Notation
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
        }),
      );
      // print(json.decode(response.body));
      final newProduct = Product(
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        title: product.title,
        id: json.decode(response.body)['name'],
        //either use                  ['name'] or .toString()
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
    //if an error is caught the next .then() will be skipped to the catch
    //assuming there's still a .then(), i removed it to adapt await method

    // print(json.decode(response.body));
    //returns the key of the object in database map
    //{name: -Ni0xX7xzdf3XqFVbx1d} for example
    //use the same id of the object in the database
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final url = Uri.https(
      'shopapp-3f885-default-rtdb.europe-west1.firebasedatabase.app',
      '/products/$id.json',
      {'auth': authToken},
    );

    try {
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
    } catch (error) {}

    final productIndex = _items.indexWhere((element) => element.id == id);
    if (productIndex >= 0) {
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.https(
      'shopapp-3f885-default-rtdb.europe-west1.firebasedatabase.app',
      '/products/$id.json',
      {'auth': authToken},
    );

    var existingProductIndex = _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();
    //if delete request fails we'll re-add the product to the list
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct.dispose();
  }
}
