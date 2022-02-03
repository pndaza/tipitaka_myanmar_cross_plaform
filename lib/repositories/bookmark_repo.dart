import '../models/bookmark.dart';
import 'bookmark_dao.dart';
import 'database.dart';

abstract class BookmarkRepository {
  Future<int> insert(Bookmark bookmark);

  Future<int> delete(Bookmark bookmark);
  Future<int> deletes(List<Bookmark> bookmarks);

  Future<int> deleteAll();

  Future<List<Bookmark>> getBookmarks();
}

class BookmarkDatabaseRepository extends BookmarkRepository {
  BookmarkDatabaseRepository(this._databaseHelper, this.dao);
  final DatabaseHelper _databaseHelper;
  final BookmarkDao dao;

  @override
  Future<int> insert(Bookmark bookmark) async {
    final db = await _databaseHelper.database;
    return await db.insert(dao.tableBookmark, dao.toMap(bookmark));
  }

  @override
  Future<int> delete(Bookmark bookmark) async {
    final db = await _databaseHelper.database;
    return await db.delete(dao.tableBookmark,
        where: '${dao.columnBookId} = ?', whereArgs: [bookmark.bookID]);
  }

  @override
  Future<int> deletes(List<Bookmark> bookmarks) async {
    int delecteds = 0;
    for (int i = 0, length = bookmarks.length; i < length; i++) {
      await delete(bookmarks[i]);
      delecteds++;
    }
    return delecteds;
  }

  @override
  Future<int> deleteAll() async {
    final db = await _databaseHelper.database;
    return await db.delete(dao.tableBookmark);
  }

  @override
  Future<List<Bookmark>> getBookmarks() async {
    final db = await _databaseHelper.database;
    var maps = await db.rawQuery('''
      SELECT ${dao.columnBookId}, ${dao.columnPageNumber}, ${dao.columnNote}, ${dao.columnName}
      FROM ${dao.tableBookmark}
      INNER JOIN ${dao.tableBooks} ON ${dao.tableBooks}.${dao.columnID} = ${dao.tableBookmark}.${dao.columnBookId}
      ''');
    return dao.fromList(maps);
  }
}
