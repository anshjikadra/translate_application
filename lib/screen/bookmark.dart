import 'package:flutter/material.dart';
import 'package:translate_application/data_base/book_mark/data_base_file.dart';
import 'package:translate_application/screen/translate_page.dart';
import 'package:translate_application/main.dart';
import 'package:translate_application/data_base/book_mark/dbmodel.dart';

bool star_book = false;

class bookmark extends StatefulWidget {

  // List<String> savebookmar=[];
  // bookmark({required this.savebookmar});

  @override
  State<bookmark> createState() => _bookmarkState();
}

class _bookmarkState extends State<bookmark> {
  @override
  void initState() {
    super.initState();
    get_data();
  }

  get_data() async {
    book_mark = await DB.getbookstring();
    print("bookmark_data==========${book_mark}");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          textAlign: TextAlign.center,
          "Favorites",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: book_mark.length,
        itemBuilder: (context, index) {
          return ListTile(
              title: Text(book_mark[index].save_bookmark),
            trailing: IconButton(onPressed: () {

              DB.delete(book_mark[index].id!);
              book_mark.removeAt(index);
              setState(() {
              });

            }, icon: Icon(Icons.star)),
          );
        },
      ),
    );
  }
}

/*
* ListView.builder(itemCount:savefavoritie.length,itemBuilder: (context, index) {
        return ListTile(
          title: Text("${savefavoritie[index]}"),
          trailing: IconButton(onPressed: () {

            // savefavoritie.removeAt(index);
            // pref.setStringList('bookmark',savefavoritie);
            // setState(() {});

          }, icon: Icon(Icons.star)),
        );
      },),
* */
