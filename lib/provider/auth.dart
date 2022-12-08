import 'package:flutter/material.dart';
import 'package:expandedflexible/model/httpexception.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  dynamic _token = null;
  DateTime _expireyDate = DateTime.now();
  dynamic _userId = null;
  dynamic autoTimer;

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
    // print(
    //     '..................inside authenticate in authenticate..beofre http.post');
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$typeofUrl?key=AIzaSyDojO9KKyNd23SYRRbFgsmXy1Ca0KlHA58';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      // print(
      //   'response..................................after http.post:' +
      //       response.body,
      // );

      final extractedResponse = json.decode(response.body);
      if (extractedResponse['error'] != null) {
        throw HttpException(extractedResponse['error']['message']);
      }
      _token = extractedResponse['idToken'];
      // print('token...........:' + _token);
      _userId = extractedResponse['localId'];
      // print('user id ...........:' + _userId);
      _expireyDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            extractedResponse['expiresIn'],
          ),
        ),
      );
      // print('expirey date for ......:');
      // print(_expireyDate);
      autoLogOuttimerset();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expireyDate': _expireyDate.toIso8601String(),
        },
      );
      print('...................................PREFS userdata JSON:');
      print(userData);
      prefs.setString('userData', userData);
      print('...................................prefs after setSring:');
      print(prefs);
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

  // Future<bool> tryAutoLogIn() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (!prefs.containsKey('userData')) {
  //     return false;
  //   }
  //   // final extractedUserData = json.decode(prefs.getString('userData'));
  //   final extractedUserData =
  //       json.decode(prefs.getString('userData')) as Map<String, dynamic>;

  //   final expireyDate = DateTime.parse(extractedUserData['expireyDate']);
  //   if (expireyDate.isBefore(DateTime.now())) {
  //     return false;
  //   }
  //   _token = extractedUserData['token'];
  //   _userId = extractedUserData['userId'];
  //   _expireyDate = expireyDate;
  //   autoLogOut();
  //   notifyListeners();
  //   return true;
  // }
  Future<bool> tryAutoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      print('...............if prefs dosnot contain key userdata');
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      print('...............if prefs  contain key userdata but expired');

      return false;
    }

    print(
        '....................prefs  contain key userdata and its extracteduserdata:');
    print(extractedUserData);

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expireyDate = expiryDate;
    notifyListeners();
    autoLogOuttimerset();
    return true;
  }

  void logOut() async {
    _expireyDate = null as DateTime;
    _token = null;
    _userId = null;
    if (autoTimer != null) {
      autoTimer.cancel();
      autoTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogOuttimerset() {
    if (autoTimer != null) {
      autoTimer.cancel();
    }
    final exactExpireTime = _expireyDate.difference(DateTime.now()).inSeconds;
    autoTimer = Timer(Duration(seconds: exactExpireTime), logOut);
  }
}
