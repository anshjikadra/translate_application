import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:translate_application/data_base/book_mark/dbmodel.dart';



class DB {
  static Database? db;
  static String table = "s_book";
  static String id = "id";
  static String title = "book_mark";
  // static String script = "script";

  static Future<Database> get dbisLoaded async {
    if (null != db) return db!;
    db = await initDB();
    return db!;
  }

  static Future<Database> initDB() async {
    var directory = await getApplicationDocumentsDirectory();
    String path = "${directory.path}/bookmark.db";
    var db = await openDatabase(path, version: 1, onCreate: onCreate);
    return db;
  }

  static onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $table($id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,$title TEXT)");
  }

  static Future<List<Data>> getbookstring() async {
    var db = await dbisLoaded;
    List<Map<String, dynamic>> data = await db.rawQuery("SELECT * FROM $table");
    return data.map((e) => Data.fromJson(e)).toList();
  }

  static Future<Data> save(Data save) async {
    var db = await dbisLoaded;
    List<Map<String, dynamic>> data = await db.rawQuery(
        "SELECT EXISTS(SELECT * FROM $table WHERE $id = '${save.id}')");
    data[0]["EXISTS(SELECT * FROM $table WHERE $id = '${save.id}')"] == 1
        ? null
        : db.insert(table, save.toJson());
    return save;
  }

  static delete(int where) async {
    var db = await dbisLoaded;
    db.delete(table, where: "$id=?", whereArgs: [where]);
  }
}
