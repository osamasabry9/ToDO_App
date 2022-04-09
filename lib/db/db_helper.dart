import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_x/models/task.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'tasks';

  static Future<void> inttDb() async {
    if (_db != null) {
      print('not null db');
      return;
    } else {
      try {
        // open the database
        String _path = await getDatabasesPath() + ' tasks.db';
        _db = await openDatabase(
          _path,
          version: _version,
          onCreate: (Database db, int version) async {
            print('Creating a new one');
            return await db.execute(
              'CREATE TABLE $_tableName ('
              'id INTEGER PRIMARY KEY AUTOINCREMENT,'
              'title STRING,note TEXT,date STRING,'
              'startTime STRING,endTime STRING,'
              'remind INTEGER,repeat STRING,'
              'color INTEGER,isCompleted INTEGER )',
            );
          },
        );
        debugPrint('open the database');
        print('open the database');
      } catch (e) {
        print(e.toString());
      }
    }
  }

  static Future<int> insert(Task task) async {
    print('insert function called');

    try {
      return await _db!.insert(_tableName, task.toJson());
    } catch (e) {
      print('the Erorr ${e.toString()}');
      return 99000;
    }
  }

  static Future<int> delete(Task? task) async {
    print('delete function called');

    try {
      return await _db!
          .delete(_tableName, where: 'id= ?', whereArgs: [task!.id]);
    } catch (e) {
      print('the Erorr ${e.toString()}');
      return 79000;
    }
  }

  static Future<int> deleteAll(Task? task) async {
    print('delete All function called');

    try {
      return await _db!.delete(_tableName);
    } catch (e) {
      print('the Erorr ${e.toString()}');
      return 79000;
    }
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print('query function called');

    try {
      return await _db!.query(_tableName);
    } catch (e) {
      print('the Erorr ${e.toString()}');
      return [
        {'Erorr': 9000}
      ];
    }
  }

  static Future<int> update(int id) async {
    print('update function called');
    return await _db!.rawUpdate('''
      UPDATE tasks SET
      isCompleted = ?
        WHERE id = ?
        ''', [1, id]);
  }

  // void createDatabase()
  // {
  //    openDatabase(
  //     'todo.db',
  //     version: 1,
  //     onCreate: (database, version)
  //     {
  //       print('database create');
  //       database.execute(
  //           'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)'
  //       ).then((value)
  //       {
  //         print('table create');
  //       }).catchError((error)
  //       {
  //         print('Error When Creating Table ${error.toString()}');
  //       });
  //     },
  //     onOpen: (database)
  //     {
  //       print('database open');
  //       getDataFormDatabase(database);
  //     },
  //   ).then((value)
  //    {
  //      database =value;
  //      emit(AppCreateDatabaseState());
  //    });
  // }
  // void createDatabase()
  // {
  //    openDatabase(
  //     'todo.db',
  //     version: 1,
  //     onCreate: (database, version)
  //     {
  //       print('database create');
  //       database.execute(
  //           'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)'
  //       ).then((value)
  //       {
  //         print('table create');
  //       }).catchError((error)
  //       {
  //         print('Error When Creating Table ${error.toString()}');
  //       });
  //     },
  //     onOpen: (database)
  //     {
  //       print('database open');
  //       getDataFormDatabase(database);
  //     },
  //   ).then((value)
  //    {
  //      database =value;
  //      emit(AppCreateDatabaseState());
  //    });
  // }

  // insertToDatabase(
  //     {
  //       required String title,
  //       required String date,
  //       required String time,
  //     })async
  // {
  //    database.transaction((txn)
  //   async {
  //     txn.rawInsert('INSERT INTO tasks(title, date, time, status) VALUES("$title","$date","$time","new")').then((value)
  //     {
  //       print('$value inserted successfully');
  //       emit(AppInsertDatabaseState());
  //       getDataFormDatabase(database);
  //     }).catchError((error){
  //       print('Error When inserting New Record ${error.toString()}');
  //     });
  //   });
  // }

  // void getDataFormDatabase(database)
  // {
  //   newTasks = [];
  //   doneTasks =[];
  //   archivedTasks =[];
  //   emit(AppGetDatabaseLoadingState());
  //   database.rawQuery('SELECT * FROM tasks').then((value)
  //   {

  //     value.forEach((element) {
  //       if (element['status'] == 'new')
  //         {
  //           newTasks.add(element);
  //         }
  //      else if(element['status'] == 'done')
  //       {
  //         doneTasks.add(element);
  //       }
  //      else
  //         archivedTasks.add(element);
  //     });
  //     emit(AppGetDatabaseState());
  //   });

  // }

  // void updateDatabase(
  // {
  // required String status,
  // required int id,
  // })async
  // {
  //   database.rawUpdate(
  //     'UPDATE tasks SET status = ? WHERE id = ?',
  //     ['$status', id],
  //   ).then((value)
  //   {
  //     getDataFormDatabase(database);
  //     emit(AppUpdateDatabaseState());
  //   });

  // }

  // void deleteDatabase({required int id,})async
  // {

  //   database.rawDelete('DELETE FROM  tasks WHERE id = ?', [id]
  //   ).then((value)
  //   {
  //     getDataFormDatabase(database);
  //     emit(AppDeleteDatabaseState());
  //   });

  // }

}
