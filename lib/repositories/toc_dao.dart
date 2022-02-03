import '../models/toc.dart';
import 'dao.dart';

class TocDao implements Dao<Toc> {
  final String tableName = 'toc';
  final String columnBookID = 'book_id';
  final String columnName = 'name';
  final String columnType = 'type';
  final String columnPageNumber = 'page_number';
  @override
  List<Toc> fromList(List<Map<String, dynamic>> query) {
    return query.map((e) => fromMap(e)).toList();
  }

  @override
  Toc fromMap(Map<String, dynamic> query) {
    return Toc(
        name: query[columnName],
        type: query[columnType],
        pageNumber: query[columnPageNumber]);
  }

  @override
  Map<String, dynamic> toMap(Toc object) {
    throw UnimplementedError();
  }
}
