class Bookmark {
  String bookID;
  int pageNumber;
  String note;
  String? bookName;
  Bookmark({
    required this.bookID,
    required this.pageNumber,
    required this.note,
    this.bookName,
  });
}
