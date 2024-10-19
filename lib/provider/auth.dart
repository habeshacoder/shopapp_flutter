import 'package:flutter/material.dart';
import 'package:online_market/model/httpexception.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth with ChangeNotifier {
  dynamic _token;
  DateTime _expireyDate = DateTime.now();
  dynamic _userId;

  bool get isAuth {
    return _token != null;
  }

  String get userId {
    return _userId;
  }

  dynamic get token {
    if (_expireyDate.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
    String email,
    String password,
    String typeofUrl,
  ) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$typeofUrl?key=AIzaSyDojO9KKyNd23SYRRbFgsmXy1Ca0KlHA58';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final extractedResponse = json.decode(response.body);
      if (extractedResponse['error'] != null) {
        throw HttpException(extractedResponse['error']['message']);
      }
      _token = extractedResponse['idToken'];
      _userId = extractedResponse['localId'];
      _expireyDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            extractedResponse['expiresIn'],
          ),
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) {
    return _authenticate(email, password, 'signInWithPassword');
  }

  // Logout method
  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expireyDate = DateTime.now();
    notifyListeners();
  }
}
