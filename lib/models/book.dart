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


