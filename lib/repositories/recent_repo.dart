import 'package:sqflite/sql.dart';

import '../models/recent.dart';
import 'database.dart';
import 'recent_dao.dart';

abstract class RecentRepository {
  Future<int> insertOrReplace(Recent recent);

  Future<int> delete(Recent recent);

  Future<int> deletes(List<Recent> recents);

  Future<int> deleteAll();

  Future<List<Recent>> getRecents();
}

class RecentDatabaseRepository implements RecentRepository {
  RecentDatabaseRepository(this.databaseProvider, this.dao);
  DatabaseHelper databaseProvider;
  final RecentDao dao;

  @override
  Future<int> insertOrReplace(Recent recent) async {
    final db = await databaseProvider.database;
    // var result = await db.update(dao.tableName, dao.toMap(recent),
    //     where: '${dao.columnBookId} = ?', whereArgs: [recent.bookID]);
    // print('update result: $result');
    // if (result == 0) {
    //   result = await db.insert(dao.tableName, dao.toMap(recent));
    // }

    var result = await db.delete(dao.tableRecent,
        where: '${dao.columnBookId} = ?', whereArgs: [recent.bookID]);
    result = await db.insert(dao.tableRecent, dao.toMap(recent),
        conflictAlgorithm: ConflictAlgorithm.ignore);

    return result;
  }

  @override
  Future<int> delete(Recent recent) async {
    final db = await databaseProvider.database;
    return await db.delete(dao.tableRecent,
        where: '${dao.columnBookId} = ?', whereArgs: [recent.bookID]);
  }

  @override
  Future<int> deletes(List<Recent> recents) async {
    int delecteds = 0;
    for (int i = 0, length = recents.length; i < length; i++) {
      await delete(recents[i]);
      delecteds++;
    }
    return delecteds;
  }

  @override
  Future<int> deleteAll() async {
    final db = await databaseProvider.database;
    return await db.delete(dao.tableRecent);
  }

  @override
  Future<List<Recent>> getRecents() async {
    final db = await databaseProvider.database;
    List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT ${dao.columnBookId}, ${dao.columnPageNumber}, ${dao.columnName}
      FROM ${dao.tableRecent}
      INNER JOIN ${dao.tableBooks} ON ${dao.tableBooks}.${dao.columnID} = ${dao.tableRecent}.${dao.columnBookId}
      ''');
    return dao.fromList(maps).reversed.toList();
  }
}
