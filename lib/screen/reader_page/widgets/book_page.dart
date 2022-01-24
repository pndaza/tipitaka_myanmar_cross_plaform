import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_selectable_text/fwfh_selectable_text.dart';
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
                factoryBuilder: () => _SelectableFactory(),
                customStylesBuilder: (element) {
                  if (element.className == 'title' ||
                      element.className == 'center' ||
                      element.className == 'ending' ||
                      element.localName == 'h1' ||
                      element.localName == 'h2' ||
                      element.localName == 'h3' ||
                      element.localName == 'h4' ||
                      element.localName == 'h5' ||
                      element.localName == 'h6') {
                    return {'text-align': 'center'};
                  }
                  /*
            if (element.localName == 'a') {
              // print('found a tag: ${element.outerHtml}');
              return {
                'color': 'black',
                'text-decoration': 'none',
              };
            }
            */
                  // no style
                  return {'text-decoration': 'none'};
                },
              );
            }),
      ),
    );
  }
}

class _SelectableFactory extends WidgetFactory with SelectableTextFactory {
  // @override
  // SelectionChangedCallback? get selectableTextOnChanged => (selection, cause) {
  //   // do something when the selection changes
  // };

}
