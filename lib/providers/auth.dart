import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  // String _token;
  // DateTime _expiryDate;
  // String userId;

  Future<void> signUp(String email, String password) async {
    final url = Uri.parse(
        //you can put https:// in the Uri.parse() string
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAV9AosuFzvn1xTqIYWxoP55m-cLeInLro');
    //https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[API_KEY]

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
    // print(json.decode(response.body));
  }

  Future<void> logIn(String email, String password) async {
    final url = Uri.parse(
        //you can put https:// in the Uri.parse() string
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAV9AosuFzvn1xTqIYWxoP55m-cLeInLro');
    //https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=[API_KEY]

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
  }
}
