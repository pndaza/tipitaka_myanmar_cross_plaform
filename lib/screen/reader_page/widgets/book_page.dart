import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_myanmar/screen/reader_page/reader_view_controller.dart';

class BookPage extends StatelessWidget {
  const BookPage({Key? key, required this.content}) : super(key: key);
  final String content;

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    return SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder<double>(
            valueListenable: context.read<ReaderViewController>().fontSize,
            builder: (_, fontSize, __) {
              return HtmlWidget(
                content,
                textStyle: TextStyle(fontSize: fontSize),
              );
            }),
      ),
    );
  }
}
