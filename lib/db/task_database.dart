import 'package:path/path.dart';
import 'package:ristask/db/user_cache.dart';
import 'package:ristask/model/task.dart';
import 'package:sqflite/sqflite.dart';

class TaskDatabase {
  late Database database;
  static const String taskTable = 'task';

  Future<bool> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'ristask_db');

    database = await openDatabase(path, version: 1, onCreate: createDatabase);
    return database.isOpen;
  }

  Future createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $taskTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        isDone INTEGER NOT NULL,
        title TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL
      );
    ''');
  }

  Future<Task> create(Task task) async {
    final id = await database.insert(taskTable, task.toJson());
    return task.copyWith(id: id);
  }

  Future<List<Task>> getAllTask() async {
    final user = await UserCache.getUser();
    final result = await database.query(taskTable, where: 'user = ?', whereArgs: [user]);
    return result.map((json) => Task.fromJson(json)).toList();
  }

  Future<int?> getCount({required String user, required String date}) async {
    int? count = Sqflite.firstIntValue(await database.rawQuery(
        'select count(*) from $taskTable where user=? and date=?', [user, date]));
    return count;
  }

  Future<int> update(Task task) async {
    return await database.update(
      taskTable,
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id]
    );
  }

  Future<int> delete(int id) async {
    return await database.delete(
      taskTable,
      where: 'id = ?',
      whereArgs: [id]
    );
  }

  Future close() async {
    database.close();
  }
}