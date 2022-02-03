import '../models/bookmark.dart';
import 'dao.dart';

class BookmarkDao extends Dao<Bookmark> {
  final tableBookmark = 'bookmark';
  final columnBookId = 'book_id';
  final columnPageNumber = 'page_number';
  final columnNote = 'note';
  final tableBooks = 'book';
  final columnID = 'id';
  final columnName = 'name'; // from book table

  @override
  Bookmark fromMap(Map<String, dynamic> query) {
    return Bookmark(
        bookID: query[columnBookId],
        pageNumber: query[columnPageNumber],
        note: query[columnNote],
        bookName: query[columnName]);
  }

  @override
  Map<String, dynamic> toMap(Bookmark object) {
    return {
      columnBookId: object.bookID,
      columnPageNumber: object.pageNumber,
      columnNote: object.note
    };
  }

  @override
  List<Bookmark> fromList(List<Map<String, dynamic>> query) {
    return query.map((e) => fromMap(e)).toList();
  }
}
