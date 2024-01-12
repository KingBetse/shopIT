import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';

class Products with ChangeNotifier {
  // ignore: non_constant_identifier_names
  List<Product> Items = [
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
  Products(this.authToken, this.userId, this.Items);
  List<Product> get items {
    return [...Items];
  }

  List<Product> get favouriteItems {
    return Items.where((element) => element.isFavourite).toList();
  }

  Product findById(String id) {
    return Items.firstWhere((element) => element.id == id);
  }

  Future<void> addProduct(Product product) async {
    var url9 = Uri.parse(
        'https://shopit-a52e1-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      print(userId);
      final response = await http.post(
        url9,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          // 'isFavorite': product.isFavourite,
          'creatorId': userId
        }),
      );

      final newProduct = Product(
          id: json.decode(response.body)["name"],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);

      Items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchProduct([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://shopit-a52e1-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString');

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }
      url = Uri.https(
        'shopit-a52e1-default-rtdb.firebaseio.com',
        '/userFavorites/$userId.json',
        {'auth': authToken},
      );
      var favoriteR = await http.get(url);
      final favoriteData = json.decode(favoriteR.body);
      print(favoriteData);
      print("HI");

      final List<Product> loadedProducts = [];
      extractedData.forEach((key, value) {
        loadedProducts.add(Product(
            id: key,
            title: value["title"],
            description: value['description'],
            price: value['price'],
            isFavourite:
                favoriteData == null ? false : favoriteData[key] ?? false,
            imageUrl: value["imageUrl"]));
      });
      Items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> UpdateProduct(String id, Product newProduct) async {
    final prodIndex = Items.indexWhere((element) => element.id == id);
    var url = Uri.parse(
        'https://shopit-a52e1-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');

    if (prodIndex >= 0) {
      await http.patch(
        url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
          'isFavorite': newProduct.isFavourite
        }),
      );
      Items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void deleteProdct(String id) {
    Items.removeWhere((element) => element.id == id);
    var url = Uri.parse(
        'https://shopit-a52e1-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    http.delete(url);

    notifyListeners();
  }
}
