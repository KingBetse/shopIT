import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.price});
}

class Cart with ChangeNotifier {
  late Map<String, CartItem> items = {};
  Map<String, CartItem> get item {
    return {...items};
  }

  int get itemCount {
    return items.length;
  }

  double get totalAmount {
    var total = 0.0;
    items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItems(String productId, double price, String title) {
    if (items.containsKey(productId)) {
      items.update(
          productId,
          (value) => CartItem(
              id: value.id,
              title: value.title,
              quantity: value.quantity + 1,
              price: value.price));
    } else {
      items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price));
    }
    notifyListeners();
  }

  void removeOne(String ProductID) {
    if (!items.containsKey(ProductID)) {
      return;
    }
    if (items[ProductID]!.quantity > 1) {
      items.update(
          ProductID,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity - 1,
              price: existingCartItem.price));
    } else {
      items.remove(ProductID);
    }
  }

  void removeItems(String productId) {
    print("ola");
    print(productId);
    print("hi");
    items.remove(productId);
    notifyListeners();
  }

  void clear() {
    items = {};
    notifyListeners();
  }
}
