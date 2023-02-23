import 'package:flutter/material.dart';
import 'package:tipitaka_myanmar/data/constants.dart';
import 'toc.dart';

abstract class TocListItem {
  int getPageNumber();
  Widget build(BuildContext context);
}

class TocHeadingOne implements TocListItem {
  TocHeadingOne(this.toc);
  final Toc toc;

  @override
  int getPageNumber() {
    return toc.pageNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Text(toc.name,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: mmFontPyidaungsu,
        ));
  }
}

class TocHeadingTwo implements TocListItem {
  TocHeadingTwo(this.toc);
  final Toc toc;

  @override
  int getPageNumber() {
    return toc.pageNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(toc.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: mmFontPyidaungsu,
            )));
  }
}

class TocHeadingThree implements TocListItem {
  TocHeadingThree(this.toc);
  final Toc toc;

  @override
  int getPageNumber() {
    return toc.pageNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 32.0),
        child: Text(toc.name,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: mmFontPyidaungsu,
            )));
  }
}

class TocHeadingFour implements TocListItem {
  TocHeadingFour(this.toc);
  final Toc toc;

  @override
  int getPageNumber() {
    return toc.pageNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 48.0),
        child: Text(toc.name,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: mmFontPyidaungsu,
            )));
  }
}

class TocHeadingFive implements TocListItem {
  TocHeadingFive(this.toc);
  final Toc toc;

  @override
  int getPageNumber() {
    return toc.pageNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 64.0),
        child: Text(toc.name,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: mmFontPyidaungsu,
            )));
  }
}
