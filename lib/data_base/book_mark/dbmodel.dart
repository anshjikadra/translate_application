import 'dart:convert';


List<Data> book_mark=[];
class Data {

  int? id;
  String save_bookmark;
  // String? english;


  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(

    id:json["id"],
    save_bookmark: json["book_mark"].toString(),

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "book_mark":save_bookmark,
  };
  Data({this.id,required this.save_bookmark});




}
