// To parse this JSON data, do
//
//     final nota = notaFromJson(jsonString);

import 'dart:convert';

Nota notaFromJson(String str) => Nota.fromJson(json.decode(str));

String notaToJson(Nota data) => json.encode(data.toJson());

class Nota {
  Nota({
    this.title,
    this.description,
    this.uid,
  });

  String? title;
  String? description;
  String? uid;

  factory Nota.fromJson(Map<String, dynamic> json) => Nota(
        title: json["title"],
        description: json["description"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "uid": uid,
      };
}
