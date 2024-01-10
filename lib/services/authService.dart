import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notes/global/environmet.dart';
import 'package:notes/helpers/helpers.dart';
import 'package:notes/models/loginResponse.dart';
import 'package:notes/models/models.dart';

class AuthService with ChangeNotifier {
  late Usuario usuario;
  bool _autenticando = false;

  final _storage = new FlutterSecureStorage();

  bool get autenticando => _autenticando;
  set autenticando(bool valor) {
    _autenticando = valor;
    notifyListeners();
  }

  // Getters del token de forma estática
  static Future<String?> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    final deleted = await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    autenticando = true;

    final data = {'email': email, 'password': password};

    var url = Uri.http(Environmet.apiURL, '/api/login/');

    final resp = await http.post(
      url,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    final getResponse = await http.post(
        Uri.parse('https://notes-backed-utm.onrender.com/api/login/'),
        body: data,
        headers: {
          'Content-Type': "application/json",
        });
    print(getResponse.body); //this is the expected response

    autenticando = false;
    print(resp.statusCode);
    print(resp.body);
    print(resp.headers);
    print(resp.isRedirect);
    print(resp.contentLength);
    print(resp.persistentConnection);
    print(resp.reasonPhrase);
    print(resp.request);

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);

      usuario = loginResponse.usuario!;

      await _guardarToken(loginResponse.token);

      return true;
    } else {
      return false;
    }
  }

  Future register(
      String nombre, String email, String password, DateTime date) async {
    try {
      autenticando = true;
      final data = {'nombre': nombre, 'email': email, 'password': password};
      var url = Uri.http(Environmet.apiURL, '/api/login/new');
      final resp = await http.post(
        url,
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );
      autenticando = false;
      if (resp.statusCode == 200) {
        final loginResponse = loginResponseFromJson(resp.body);
        usuario = loginResponse.usuario!;
        await _guardarToken(loginResponse.token);

        return true;
      } else {
        return {};
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');

    var url = Uri.http(Environmet.apiURL, '/api/login/renew/');

    final resp = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token != null ? token : '',
      },
    );
    print(resp.statusCode);
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario!;
      await _guardarToken(loginResponse.token);
      return true;
    } else {
      logout();
      return false;
    }
  }

  Future _guardarToken(String? token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    // Delete value
    await _storage.delete(key: 'token');
  }
}
