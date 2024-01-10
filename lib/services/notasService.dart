import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:notes/global/environmet.dart';
import 'package:notes/models/models.dart';
import 'package:notes/services/services.dart';

class NotasService with ChangeNotifier {
  final _storage = new FlutterSecureStorage();
  bool _eliminacion = false;
  bool _actualizacion = false;

  bool get eliminacion => _eliminacion;
  set eliminacion(bool valor) {
    _eliminacion = valor;
    notifyListeners();
  }

  bool get actualizacion => _actualizacion;
  set actualizacion(bool valor) {
    _actualizacion = valor;
    notifyListeners();
  }

  Future<List<Nota>?> getNotas() async {
    try {
      var url = Uri.http(Environmet.apiURL, '/api/notas/');
      var token = await AuthService.getToken();
      final resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': token != null ? token : ''
        },
      );

      final notasResponse = notasResponseFromJson(resp.body);
      return notasResponse.notas;
    } catch (e) {
      return [];
    }
  }

  Future newNote(String title, String description) async {
    final token = await _storage.read(key: 'token');
    final data = {'title': title, 'description': description};
    var url = Uri.http(Environmet.apiURL, '/api/notas/new/');
    final resp = await http.post(
      url,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token != null ? token : '',
      },
    );

    if (resp.statusCode == 200) {
      // final notasResponse = nota!;
      // await _guardarToken(loginResponse.token);

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future updateNote(String title, String description, String uid) async {
    actualizacion = true;
    final token = await _storage.read(key: 'token');
    final data = {'title': title, 'description': description, 'uid': uid};
    var url = Uri.http(Environmet.apiURL, '/api/notas/update/');
    final resp = await http.put(
      url,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token != null ? token : '',
      },
    );

    if (resp.statusCode == 200) {
      // final notasResponse = nota!;
      // await _guardarToken(loginResponse.token);
      actualizacion = false;
      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future deleteNote(uid) async {
    eliminacion = true;
    final token = await _storage.read(key: 'token');
    final data = {'uid': uid};
    var url = Uri.http(Environmet.apiURL, '/api/notas/delete/');
    final resp = await http.delete(
      url,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token != null ? token : '',
      },
    );

    if (resp.statusCode == 200) {
      // final notasResponse = nota!;
      // await _guardarToken(loginResponse.token);

      eliminacion = false;
      notifyListeners();
      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }
}
