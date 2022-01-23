import 'package:freezed_annotation/freezed_annotation.dart';

part 'book.freezed.dart';

@freezed
class Book with _$Book {
  const factory Book(
      {required String id,
      required String name,
      int? categoryId,
      String? categoryName,
      int? firstPage,
      int? lastPage,
      int? count}) = _Book;
}

class BookDao {
  final tableName = 'book';
  final columnID = 'id';
  final columnName = 'name';
  final columnCategoryID = 'category_id';
  final columnCategoryDescription = 'category_name';
  final columnFirstPage = 'first_page';
  final columnLastPage = 'last_page';
  final columnCount = 'number_of_pages';

  Book fromMap(Map<String, dynamic> map) {
    return Book(
      id: map[columnID] as String,
      name: map[columnName] as String,
      categoryId:
          map[columnCategoryID] != null ? map[columnCategoryID] as int : null,
      categoryName: map[columnCategoryDescription] != null
          ? map[columnCategoryDescription] as String
          : null,
      firstPage:
          map[columnFirstPage] != null ? map[columnFirstPage] as int : null,
      lastPage: map[columnLastPage] != null ? map[columnLastPage] as int : null,
      count: map[columnCount] != null ? map[columnCount] as int : null,
    );
  }

  List<Book> fromList(List<Map<String, dynamic>> query) {
    return query.map((e) => fromMap(e)).toList();
  }
}
