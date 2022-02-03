
import 'database.dart';

abstract class ParagraphRepository {
  Future<int> getFirstParagraph(String bookID);

  Future<int> getLastParagraph(String bookID);

  Future<int> getPageNumber(String bookID, int paragraph);
}

class ParagraphDatabaseRepository implements ParagraphRepository {
  ParagraphDatabaseRepository(this.databaseProvider);
  final DatabaseHelper databaseProvider;

  final tableName = 'para_page_map';
  final columnBookId = 'book_id';
  final columnParagraphNumber = 'paragraph_number';
  final columnPageNumber = 'page_number';

  @override
  Future<int> getFirstParagraph(String bookID) async {
    final db = await databaseProvider.database;
    List<Map> maps = await db.query(tableName,
        columns: [columnParagraphNumber],
        where: '$columnBookId = ?',
        whereArgs: [bookID]);
    return maps.first[columnParagraphNumber];
  }

  @override
  Future<int> getLastParagraph(String bookID) async {
    final db = await databaseProvider.database;
    List<Map> maps = await db.query(tableName,
        columns: [columnParagraphNumber],
        where: '$columnBookId = ?',
        whereArgs: [bookID]);
    return maps.last[columnParagraphNumber];
  }

  @override
  Future<int> getPageNumber(String bookID, int paragraphNumber) async {
    final db = await databaseProvider.database;
    List<Map> maps = await db.query(tableName,
        columns: [columnPageNumber],
        where:
            '$columnBookId = ? AND $columnParagraphNumber = ?',
        whereArgs: [bookID, paragraphNumber]);
    return maps.first[columnPageNumber];
  }
}
