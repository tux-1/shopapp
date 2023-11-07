import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/exceptions.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  String get userId {
    return _userId.toString();
  }

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

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    //const is a compilation time constant, final is a runtime constant
    final url = Uri.parse(
        //you can put https:// in the Uri.parse() string
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAV9AosuFzvn1xTqIYWxoP55m-cLeInLro');
    //https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[API_KEY]
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
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        print('An error occured: ' + responseData['error']['message']);
        throw HttpException(
            'An error occured: ' + responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      // print(_token);
      // print(_userId);
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> logIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
