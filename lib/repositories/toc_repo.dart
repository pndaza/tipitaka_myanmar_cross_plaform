
import '../models/toc.dart';
import 'database.dart';
import 'toc_dao.dart';

abstract class TocRepository {
  Future<List<Toc>> getTocs(String bookID);
}

class TocDatabaseRepository implements TocRepository {
  final dao = TocDao();
  final DatabaseHelper databaseHelper;

  TocDatabaseRepository(this.databaseHelper);
  
  @override
  Future<List<Toc>> getTocs(String bookID) async {
    final db = await databaseHelper.database;
    var results = await db.query(dao.tableName,
        columns: [dao.columnName, dao.columnType, dao.columnPageNumber],
        where: '${dao.columnBookID} = ?',
        whereArgs: [bookID]);
    return dao.fromList(results);
  }
}
