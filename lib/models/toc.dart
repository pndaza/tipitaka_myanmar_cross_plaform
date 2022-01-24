import 'package:tipitaka_myanmar/models/toc_list_item.dart';

class Toc {
  String name;
  int type;
  int pageNumber;
  Toc({
    required this.name,
    required this.type,
    required this.pageNumber,
  });

  TocListItem toTocItem() {
    switch (type) {
      case 1:
        return TocHeadingOne(this);
      case 2:
        return TocHeadingTwo(this);
      case 3:
        return TocHeadingThree(this);
      case 4:
        return TocHeadingFour(this);
      default:
        return TocHeadingOne(this);
    }
  }
}
