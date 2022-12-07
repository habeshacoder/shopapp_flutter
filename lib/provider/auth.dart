import 'package:flutter/material.dart';
import 'package:expandedflexible/model/httpexception.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth with ChangeNotifier {
  dynamic _token = null;
  DateTime _expireyDate = DateTime.now();
  dynamic _userId = null;

  bool get isAuth {
    return _token != null;
  }

  String get userId {
    return _userId;
  }

  dynamic get token {
    if (_expireyDate != null &&
        _expireyDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
    String email,
    String password,
    String typeofUrl,
  ) async {
    print(
        '..................inside authenticate in authenticate..beofre http.post');
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$typeofUrl?key=AIzaSyDojO9KKyNd23SYRRbFgsmXy1Ca0KlHA58';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      print(
        'response..................................after http.post:' +
            response.body,
      );

      final extractedResponse = json.decode(response.body);
      if (extractedResponse['error'] != null) {
        throw HttpException(extractedResponse['error']['message']);
      }
      _token = extractedResponse['idToken'];
      print('token...........:' + _token);
      _userId = extractedResponse['localId'];
      print('user id ...........:' + _userId);
      _expireyDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            extractedResponse['expiresIn'],
          ),
        ),
      );
      print('expirey date for ......:');
      print(_expireyDate);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> signUp(String email, String password) {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
