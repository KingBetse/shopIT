import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:shop_it/provider/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem with ChangeNotifier {
  final String id;
  final double amount;
  final List<CartItem> product;
  final DateTime daeTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.product,
      required this.daeTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this.orders);
  List<OrderItem> get order {
    return [...orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    var url = Uri.parse(
        'https://shopit-a52e1-default-rtdb.firebaseio.com/order/$userId.json?auth=$authToken');
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'daeTime': timeStamp.toIso8601String(),
          'product': cartProducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price
                  })
              .toList()
        }),
      );

      orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)["name"],
          amount: total,
          product: cartProducts,
          daeTime: timeStamp,
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchOrder() async {
    var url = Uri.parse(
        'https://shopit-a52e1-default-rtdb.firebaseio.com/order/$userId.json?auth=$authToken');

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
// if(extractedData =null){

// }

      final List<OrderItem> loadedOrders = [];
      extractedData.forEach((key, value) {
        loadedOrders.add(OrderItem(
            id: key,
            amount: value["amount"],
            daeTime: DateTime.parse(value['daeTime']),
            product: (value['product'] as List<dynamic>)
                .map((e) => CartItem(
                    id: e["id"],
                    title: e["title"],
                    quantity: e["quantity"],
                    price: e["price"]))
                .toList()));
      });
      orders = loadedOrders;
      for (var orderItem in loadedOrders) {
        print("Key: ${orderItem.id}");
        print("Value: ${orderItem.amount}");
      }
      // loadedOrders
      // notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void deleteProdct(
    String userId,
    String id,
  ) async {
    // Items.removeWhere((element) => element.id == id);
    var url = Uri.parse(
        'https://shopit-a52e1-default-rtdb.firebaseio.com/order/$userId/$id.json?auth=$authToken');

    http.delete(url);

    notifyListeners();
  }
}
