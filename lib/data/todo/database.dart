import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/data/todo/todo.dart';

class DatabaseHelper {
  static final _databaseName = "todo.db";
  static final _databaseVersion = 1;
  static final todoTable = "todo";

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate,
      onUpgrade: _onUpgrade);
  }
  // 앱이 처음 실행될때 데이터 베이스를 생성
  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $todoTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date INTEGER DEFAULT 0,
      done INTEGER DEFAULT 0,
      title String,
      memo String,
      color INTEGER,
      category String
    )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {}
  
  // 투두 입력, 수정, 불러오기
  Future<int> insertTodo(Todo todo) async {
    Database db = await instance.database;

    if(todo.id == null) {
      // 새로 추가, id는 자동 생성
      Map<String, dynamic> row = {
        "title": todo.title,
        "date": todo.date,
        "done": todo.done,
        "memo": todo.memo,
        "color": todo.color,
        "category": todo.category
      };
      // map 구조를 데이터 베이스에 넣기
      return await db.insert(todoTable, row);
    }else{
      Map<String, dynamic> row = {
        "title": todo.title,
        "date": todo.date,
        "done": todo.done,
        "memo": todo.memo,
        "color": todo.color,
        "category": todo.category
      };
      // 해당 아이디어의 정보를 수정, 없으면 새로운 아이디를 위가하여 위의 코드를 실행
      return await db.update(todoTable, row, where: "id = ?", whereArgs: [todo.id]);
    }

  }

  // 투두 리스트를 전체 불러오는 기능
  Future<List<Todo>> getAllTodo() async {
    Database db = await instance.database;
    List<Todo> todos = [];

    // todoTable 있는 데이터를 다 가져와라
    var queries = await db.query(todoTable);

    // 투두 리스트에 다 담아주고
    for(var q in queries){
      todos.add(Todo(
        id: q["id"],
        title: q["title"],
        date: q["date"],
        done: q["done"],
        memo: q["memo"],
        category: q["category"],
        color: q["color"],
      ));
    }

    return todos;
  }

  // 해당 날짜의 투두 리스트를 전체 불러오는 기능
  Future<List<Todo>> getTodoByDate(int date) async {
    Database db = await instance.database;
    List<Todo> todos = [];

    // todoTable 있는 데이터를 다 가져와라
    var queries = await db.query(todoTable, where: "date = ?", whereArgs: [date]);

    // 투두 리스트에 다 담아주고
    for(var q in queries){
      todos.add(Todo(
        id: q["id"],
        title: q["title"],
        date: q["date"],
        done: q["done"],
        memo: q["memo"],
        category: q["category"],
        color: q["color"],
      ));
    }

    return todos;
  }

  // 투두 삭제
  Future<int> deleteTodo(int id) async {
    Database db = await instance.database;
    return await db.delete(todoTable, where: "id = ?", whereArgs: [id]);
  }

}
