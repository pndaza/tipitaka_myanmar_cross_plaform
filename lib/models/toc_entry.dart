import 'toc.dart';

class TocEntry {
  final Toc header;
  List<TocEntry>? children;

  TocEntry({required this.header, this.children});

  addChildern(List<TocEntry> children) {
    this.children = children;
  }
}
