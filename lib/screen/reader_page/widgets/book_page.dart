import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_myanmar/data/constants.dart';

import '../../../utils/mm_number.dart';
import '../reader_view_controller.dart';

class BookPage extends StatelessWidget {
  const BookPage(
      {Key? key,
      required this.pageContent,
      required this.pageNumber,
      this.textToHighlight = ''})
      : super(key: key);
  final String pageContent;
  final int pageNumber;
  final String textToHighlight;

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
              var htmlContent = _addPageNumber(pageContent, pageNumber);
              htmlContent = _addHighlight(htmlContent, textToHighlight);
              return SelectionArea(
                selectionControls: MaterialTextSelectionControls(),
                child: HtmlWidget(
                  htmlContent,
                  textStyle: TextStyle(
                    fontSize: fontSize,
                    fontFamily: mmFontPyidaungsu,
                  ),
                  factoryBuilder: () => CustomWidgetFactory(),
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

                    if (element.className == 'highlighted') {
                      return {'background': 'orange', 'color': 'black'};
                    }

                    if (element.className == 'page_number') {
                      return {'color': 'orange'};
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
                ),
              );
            }),
      ),
    );
  }

  String _addPageNumber(String pageContent, int pageNumber) {
    // page number will not shown in first page
    if (pageNumber == 1) {
      return pageContent;
    } else {
      return '<p class="page_number">${MmNumber.get(pageNumber)}</p><br/>$pageContent';
    }
  }

  String _addHighlight(String pageContent, String textToHighlight) {
    if (textToHighlight.isEmpty) {
      return pageContent;
    } else {
      return pageContent.replaceAll(
          textToHighlight, '<span class="highlighted">$textToHighlight</span>');
    }
  }
}

class CustomWidgetFactory extends WidgetFactory {
  @override
  Widget? buildText(BuildMetadata meta, TextStyleHtml tsh, InlineSpan text) {
    if (meta.overflow == TextOverflow.clip && text is TextSpan) {
      return Text.rich(
        text,
        maxLines: meta.maxLines > 0 ? meta.maxLines : null,
        textAlign: tsh.textAlign ?? TextAlign.start,
        textDirection: tsh.textDirection,
        textScaleFactor: 1.0,
      );
    }

    return super.buildText(meta, tsh, text);
  }
}
