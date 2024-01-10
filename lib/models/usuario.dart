// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  Usuario({
    this.date,
    this.nombre,
    this.correo,
    this.password,
    this.uid,
  });

  String? date;
  String? nombre;
  String? correo;
  String? password;
  String? uid;

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        date: json["date"],
        nombre: json["nombre"],
        correo: json["correo"],
        password: json["password"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "nombre": nombre,
        "correo": correo,
        "password": password,
        "uid": uid,
      };
}
