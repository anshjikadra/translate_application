// ignore_for_file: depend_on_referenced_packages
import 'dart:typed_data';


import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;

import 'package:translate_application/data_base/book_mark/dbmodel.dart';




class DictionaryDataBaseHelper {
  late Database db;


  Future<void> init() async {
    io.Directory applicationDirectory = await getApplicationDocumentsDirectory();

    String dbPathEnglish =
    path.join(applicationDirectory.path, "myfile.sqlite3");

    bool dbExistsEnglish = await io.File(dbPathEnglish).exists();

    if (!dbExistsEnglish) {
      // Copy from asset
      ByteData data = await rootBundle.load(path.join("assets", "english_arabic_dict.sqlite3"));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await io.File(dbPathEnglish).writeAsBytes(bytes, flush: true);
    }

    db = await openDatabase(dbPathEnglish);
  }

//------------------get data--------------
  Future<List<Data>> getCases() async {
    if (db == null) {
      throw "bd is not initiated, initiate using [init(db)] function";
    }
    List<Map<String, dynamic>> words = [];
    words = await db.rawQuery("SELECT * FROM Dictionary");
    return words.map((e) => Data.fromJson(e)).toList();
  }

  //-----------------update bookmark detail------------
  Future<List<Data>> getById(id) async {
    if (db == null) {
      throw "bd is not initiated, initiate using [init(db)] function";
    }
    List<Map<String, dynamic>> words = [];
    words = await db.rawQuery("SELECT * FROM Dictionary WHERE id = $id");
    return words.map((e) => Data.fromJson(e)).toList();
  }

  //-----------------------get bookmark detail---------------
  Future<List<Data>> getBookmarkDetail() async {
    if (db == null) {
      throw "bd is not initiated, initiate using [init(db)] function";
    }
    List<Map<String, dynamic>> words = [];
    words = await db.rawQuery("SELECT * FROM sunnah WHERE is_bookmark==1");
    return words.map((e) => Data.fromJson(e)).toList();
  }

  Future<List<Data>> removeBookmark(id) async {
    if (db == null) {
      throw "bd is not initiated, initiate using [init(db)] function";
    }
    List<Map<String, dynamic>> words = [];
    words = await db
        .rawQuery("UPDATE sunnah SET is_bookmark = '0' WHERE id = '$id'");
    print("UPDATE sunnah SET is_bookmark = '0' WHERE id = '$id'");
    return words.map((e) => Data.fromJson(e)).toList();
  }

  //--------------------search page number---------------
  Future<List<Data>> updateDetail(id) async {
    if (db == null) {
      throw "bd is not initiated, initiate using [init(db)] function";
    }
    List<Map<String, dynamic>> words = [];
    words = await db.rawQuery("SELECT * FROM sunnah WHERE id==id");
    return words.map((e) => Data.fromJson(e)).toList();
  }

  Future<bool> checkifAdded(int id) async {
    var queryResult = await db.rawQuery('SELECT * FROM sunnah WHERE id=$id');
    if (queryResult.isEmpty) {
      return false;
    }
    return true;
  }
}
