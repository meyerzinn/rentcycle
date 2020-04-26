import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentcycle/create_request_title_page.dart';
import 'view_requests.dart';
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
        title: GoogleFonts.roboto(
          fontWeight: FontWeight.bold,
          fontSize: 26,
          textStyle: textTheme.title,
        )
      ),
      elevation: 0,
      iconTheme: IconTheme.of(context).copyWith(color: Colors.black),
    ),
    highlightColor: Colors.transparent,
    textTheme: textTheme.copyWith(
      // section/card titles
      title: GoogleFonts.openSans(
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
        fontSize: 16,
        textStyle: textTheme.title,
      ),
      subtitle: GoogleFonts.openSans(
        fontStyle: FontStyle.normal,
        fontSize: 12,
        textStyle: textTheme.subtitle
      ),
      display1: GoogleFonts.roboto(
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
        color: ACCENT_COLOR,
        textStyle: textTheme.display1,
        fontSize: 35
      )
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
      initialRoute: '/',
      routes: {
        '/requests': (context) => RequestListWidget(),
        '/requests/new': (context) => CreateRequestTitlePage(),
      },
      home: CreateRequestTitlePage(),
    );
  }
}
