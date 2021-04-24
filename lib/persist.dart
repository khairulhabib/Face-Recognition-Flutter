import 'package:Face_recognition/person.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbProvider {
  DbProvider._();

  static final DbProvider db = DbProvider._();

  Database _database;

  Future<Database> get database async {
    if(_database!=null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async{
    print("Initiate DB");
    String path = join(await getDatabasesPath(), 'person_database.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE Person ("
            "id INTEGER PRIMARY KEY, "
            "nik TEXT,"
            "name TEXT,"
            "embedding TEXT)");
      }
    );
  }

  newPerson(Person newPerson) async {
    print("Save New Person");
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Person");
    int id = table.first["id"];
    var raw = await db.rawInsert("INSERT INTO Person(id,nik,name,embedding) "
        "VALUES (?,?,?,?)",
        [id,newPerson.nik,newPerson.name,newPerson.embedding]);
    return raw;
  }

  getPersonByNik(String nik) async {
    final db = await database;
    var res = await db.query("Person", where: "nik = ?", whereArgs: [nik]);
    return res.isNotEmpty ? Person.fromMap(res.first) : null;
  }

  getPerson(int id) async {
    final db = await database;
    var res = await db.query("Person", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Person.fromMap(res.first) : null;
  }

  Future<List<Person>> getAll() async {
    print("Get All Person");
    final db = await database;
    var res = await db.query("Person");
    List<Person> list = res.isNotEmpty ? res.map((p) => Person.fromMap(p)).toList() : [];
    return list;
  }

  deletePerson(int id) async {
    final db = await database;
    return db.delete("Person", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Person");
  }

}