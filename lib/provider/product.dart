import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  void _setFavValue(bool newValue) {
    isFavourite = newValue;
    notifyListeners();
  }

//   Future<void> toggleFavoriteStatus(String token, String userId) async {
//     final oldStatus = isFavourite;
//     isFavourite = !isFavourite;
//     notifyListeners();
//     final url = Uri.https(
//         // 'flutter-update.firebaseio.com',
//         //   '/userFavorites/$userId/$id.json?auth=$token'
//         'https://shopit-a52e1-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token');
//     try {
//       final response = await http.patch(
//         url,
//         body: json.encode({
//           isFavourite,
//         }),
//       );
//       if (response.statusCode >= 400) {
//         _setFavValue(oldStatus);
//       }
//       notifyListeners();
//     } catch (error) {
//       _setFavValue(oldStatus)
//     }
//   }
// }
  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();

    final url = Uri.https(
      'shopit-a52e1-default-rtdb.firebaseio.com',
      '/userFavorites/$userId/$id.json',
      {'auth': token},
    );

    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavourite,
        ),
      );

      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }

      notifyListeners();
    } catch (error) {
      print(error);
      _setFavValue(oldStatus);
    }
  }
}
