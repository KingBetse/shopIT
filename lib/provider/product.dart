import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  String id;
  String title;
  String description;
  double price;
  bool isFavourite;
  String imageUrl;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.isFavourite = false,
    required this.imageUrl,
  });

  void toggleFavoriteStatus() {
    isFavourite = !isFavourite;
    notifyListeners();
  }
}
