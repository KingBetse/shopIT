import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/httpExeption.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    try {
      var url = Uri.parse(
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyDp0tTQ1HokQRIUKiZkUVlH--UHTOpOHh8');

      final response = await http.post(
        url,
        body: json.encode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );
      print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      // print(_token);
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      print(_expiryDate);
      _userId = responseData['localId'];
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    var url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDp0tTQ1HokQRIUKiZkUVlH--UHTOpOHh8');
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));
      print(json.decode(response.body));
      // return _authenticate(email, password, "signupNewUser");
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _userId = responseData['localId'];
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> logIn(
    String email,
    String password,
  ) async {
    // var url = Uri.parse(
    //     'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegmentt?key=AIzaSyDp0tTQ1HokQRIUKiZkUVlH--UHTOpOHh8');

    // final response = await http.post(url,
    //     body: json.encode({
    //       "email": email,
    //       "password": password,
    //       "returnSecureToken": true,
    //     }));
    return _authenticate(email, password, "verifyPassword");
  }

  void logOut() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    notifyListeners();
  }
}
