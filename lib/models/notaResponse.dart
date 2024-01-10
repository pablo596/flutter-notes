// To parse this JSON data, do
//
//     final notasResponse = notasResponseFromJson(jsonString);

import 'dart:convert';

import 'package:notes/models/models.dart';

NotasResponse notasResponseFromJson(String str) =>
    NotasResponse.fromJson(json.decode(str));

String notasResponseToJson(NotasResponse data) => json.encode(data.toJson());

class NotasResponse {
  NotasResponse({
    this.ok,
    this.notas,
  });

  bool? ok;
  List<Nota>? notas;

  factory NotasResponse.fromJson(Map<String, dynamic> json) => NotasResponse(
        ok: json["ok"],
        notas: List<Nota>.from(json["notas"].map((x) => Nota.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "notas": List<dynamic>.from(notas!.map((x) => x.toJson())),
      };
}
