import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentcycle/landing.dart';
import 'view-requests.dart';
import 'util.dart';

void main() => runApp(MyApp());

ThemeData buildTheme(BuildContext context) {
  final textTheme = Theme.of(context).textTheme;
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: Colors.white,
      brightness: Brightness.light,
      textTheme: textTheme.copyWith(
          title: GoogleFonts.merriweather(
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.italic,
        fontSize: 24,
        textStyle: textTheme.title,
      )),
      elevation: 0,
      iconTheme: IconTheme.of(context).copyWith(color: Colors.black),
    ),
    highlightColor: Colors.transparent,
    textTheme: textTheme.copyWith(
      // preview snippet
      body2: GoogleFonts.merriweather(
        fontWeight: FontWeight.w300,
        fontSize: 16,
        textStyle: textTheme.body2,
      ),
      // time in latest updates
      body1: GoogleFonts.libreFranklin(
        fontWeight: FontWeight.w500,
        fontSize: 11,
        color: Colors.black.withOpacity(0.5),
        textStyle: textTheme.body1,
      ),
      // preview headlines
      headline: GoogleFonts.libreFranklin(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        textStyle: textTheme.headline,
      ),
      // (caption 2), preview category, stock ticker
      subtitle: GoogleFonts.robotoCondensed(
        fontWeight: FontWeight.w700,
        fontSize: 16,
      ),
      subhead: GoogleFonts.libreFranklin(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        textStyle: textTheme.subhead,
      ),
      // section titles: Top Highlights, Last Updated...
      title: GoogleFonts.merriweather(
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.italic,
        fontSize: 14,
        textStyle: textTheme.title,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rentcycle',
      theme: buildTheme(context).copyWith(brightness: Brightness.light),
      home: RequestListWidget(users[0]),
    );
  }
}
