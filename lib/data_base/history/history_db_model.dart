import 'dart:convert';


List<H_data> s_history=[];
class H_data {

  int? id;
  String history_data;
  // String? english;


  factory H_data.fromRawJson(String str) => H_data.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory H_data.fromJson(Map<String, dynamic> json) => H_data(

    id:json["id"],
    history_data: json["save_history"].toString(),

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "save_history":history_data,
  };
  H_data({this.id,required this.history_data});

}
