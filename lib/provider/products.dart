import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';

class Products with ChangeNotifier {
  // ignore: non_constant_identifier_names
  List<Product> Items = [];
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
      // print(userId);
      final response = await http.post(
        url9,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'discount': product.discount,
          'brand': product.brand,
          'size': product.size,
          'gender': product.gender,
          // 'isFavorite': product.isFavourite,
          'creatorId': userId
        }),
      );

      final newProduct = Product(
          id: json.decode(response.body)["name"],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          brand: product.brand,
          size: product.size,
          gender: product.gender,
          discount: product.discount);

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
      print("ssdfsdfdsfdsf ${extractedData}");

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

      final List<Product> loadedProducts = [];
      extractedData.forEach((key, value) {
        loadedProducts.add(
          Product(
              id: key,
              title: value["title"],
              description: value['description'],
              price: value['price'],
              isFavourite:
                  favoriteData == null ? false : favoriteData[key] ?? false,
              imageUrl: value["imageUrl"],
              brand: value['brand'],
              size: value['size'],
              gender: value['gender'],
              discount: value['discount']
              // isDiscount:
              //     discountData == null ? false : favoriteData[key] ?? false,
              ),
        );
      });
      Items = loadedProducts;
      print(Items);
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
          'isFavorite': newProduct.isFavourite,
          'brand': newProduct.brand,
          'size': newProduct.size,
          'gender': newProduct.gender,
          'discount': newProduct.discount,
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
