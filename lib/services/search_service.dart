import '../models/book.dart';
import '../models/search_result.dart';
import '../repositories/book_dao.dart';
import '../repositories/book_repo.dart';
import '../repositories/database.dart';
import 'asset_service.dart';

class SearchService {
  SearchService._();

  static Future<List<SearchResult>> getResults(String searchWord) async {
    List<SearchResult> results = [];
    DatabaseHelper databaseHelper = DatabaseHelper();
    BookRepository bookRepository =
        DatabaseBookRepository(databaseHelper, BookDao());
    List<Book> books = await bookRepository.fetchBooks();
    for (int i = 0; i < books.length; i++) {
      String bookContent =
          await AssetBookReader.loadContent(bookID: books[i].id);
      bookContent = _removeAllHtmlTags(bookContent);
      List<String> pages = bookContent.split('--');
      // pages.removeAt(0);
      pages.removeLast();
      // print('number of page: ${pages.length}');
      for (int j = 0; j < pages.length; j++) {
        int start = 0;
        while (true) {
          int index = pages[j].indexOf(searchWord, start);
          if (index == -1) {
            break;
          } else {
            // print('${books[i].name} page-$j');
            // print('found at $index');
            String description =
                _extractDescription(pages[j], index, searchWord);
            start = (index + 1);
            final book = Book(id: books[i].id, name: books[i].name);
            final pageNumber = j + 1;
            results.add(SearchResult(
              book: book,
              pageNumber: pageNumber,
              description: description,
              textToHighlight: searchWord,
            ));
          }
        }
      }
    }
    return results;
  }

  static String _removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }

  static String _extractDescription(
      String pageContent, int index, String searchWord) {
    int length = pageContent.length;
    int startIndexOfQuery = index;
    int endIndexOfQuery = startIndexOfQuery + searchWord.length;
    int briefCharCount = 65;
    int counter = 1;

    while (startIndexOfQuery - counter >= 0 && counter < briefCharCount) {
      counter++;
    }
    int startIndexOfBrief = startIndexOfQuery - (counter - 1);

    counter = 1; //reset counter
    while (endIndexOfQuery + counter < length && counter < briefCharCount) {
      counter++;
    }
    int endIndexOfBrief = endIndexOfQuery + (counter - 1);

    return pageContent.substring(startIndexOfBrief, endIndexOfBrief);
  }
}
