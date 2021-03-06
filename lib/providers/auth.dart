import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _user_id;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get user_id {
    return _user_id;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCrCAMUX8YDVGIp9nQ9OIdcN7AU1o43PT0';
    try {
      final res = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final responseData = json.decode(res.body);
      if (responseData['error'] != null) {
        HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _user_id = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresId'])));
     _autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();

      String userData = json.encode({
        'token': _token,
        'userId': _user_id,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (e) {
      throw e;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userData')) return false;

    final Map<String, Object> extractedData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;

    final expiryDate = DateTime.parse(extractedData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) return false;

    _token = extractedData['token'];
    _user_id = extractedData['userId'];
    _expiryDate = expiryDate;

    notifyListeners();
_autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _user_id = null;
    _expiryDate = null;

    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();

    prefs.clear();
  }


   Future<void> _autoLogout() async {

 if (_authTimer != null) {
      _authTimer.cancel();
     }
     final timeToExpiry=_expiryDate.difference(DateTime.now()).inSeconds;
     _authTimer=Timer(Duration(seconds:timeToExpiry ),logout);


   }
}
