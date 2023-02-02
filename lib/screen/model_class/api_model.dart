import 'dart:convert';

Translate translateFromJson(String str) => Translate.fromJson(json.decode(str));

String translateToJson(Translate data) => json.encode(data.toJson());

class Translate {
  Translate({
    required this.trans,
    required this.orig,
    required this.backend,
  });

  String trans;
  String orig;
  int backend;

  factory Translate.fromJson(Map<String, dynamic> json) => Translate(
    trans: json["trans"],
    orig: json["orig"],
    backend: json["backend"],
  );

  Map<String, dynamic> toJson() => {
    "trans": trans,
    "orig": orig,
    "backend": backend,
  };
}


/*
* class translate{
* Translate
* }
* */
