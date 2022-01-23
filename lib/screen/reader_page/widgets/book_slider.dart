import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_myanmar/screen/reader_page/reader_view_controller.dart';

class BookSlider extends StatefulWidget {
  final int firstPage;
  final int lastPage;
  final int currentPage;

  const BookSlider(
      {Key? key,
      required this.firstPage,
      required this.lastPage,
      required this.currentPage})
      : super(key: key);

  @override
  State<BookSlider> createState() => _BookSliderState();
}

class _BookSliderState extends State<BookSlider> {
  late double _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentPage.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: const SliderThemeData(),
      child: Slider(
        value: _currentIndex,
        min: widget.firstPage.toDouble(),
        max: widget.lastPage.toDouble(),
        label: _currentIndex.round().toString(),
        divisions: (widget.lastPage - widget.firstPage) + 1,
        onChanged: (value) {
          setState(() => _currentIndex = value);
        },
        onChangeEnd: context.read<ReaderViewController>().onSliderPageChanged,
      ),
    );
  }
}
