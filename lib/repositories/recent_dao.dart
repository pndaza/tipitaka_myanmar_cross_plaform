import 'package:tipitaka_myanmar/models/recent.dart';

import 'dao.dart';

class RecentDao implements Dao<Recent> {
  final tableRecent = 'recent';
  final columnBookId = 'book_id';
  final columnPageNumber = 'page_number';
  final tableBooks = 'book';
  final columnID = 'id';
  final columnName = 'name'; // from book table

  @override
  List<Recent> fromList(List<Map<String, dynamic>> query) {
    return query.map((e) => fromMap(e)).toList();
  }

  @override
  Recent fromMap(Map<String, dynamic> query) {
    return Recent(
        bookID: query[columnBookId],
        pageNumber: query[columnPageNumber],
        bookName: query[columnName]);
  }

  @override
  Map<String, dynamic> toMap(Recent object) {
    return <String, dynamic>{
      columnBookId: object.bookID,
      columnPageNumber: object.pageNumber
    };
  }
}
