import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentcycle/create_request.dart';
import 'view_requests.dart';
import 'util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'keys.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'client',
    options: AppFirebaseOptions,
  );
  runApp(MyApp(Firestore(app: app)));
}

ThemeData buildTheme(BuildContext context) {
  final textTheme = Theme.of(context).textTheme;
  return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        color: Colors.transparent,
        brightness: Brightness.light,
        textTheme: TextTheme(
          title: GoogleFonts.raleway(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontStyle: FontStyle.italic,
            fontSize: 32,
          ),
        ),
        elevation: 0,
        iconTheme: IconTheme.of(context).copyWith(color: Colors.black),
      ),
      highlightColor: Colors.transparent,
      textTheme: textTheme.copyWith(
          // section/card titles
          title: GoogleFonts.openSans(
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
            fontSize: 18,
            textStyle: textTheme.title,
          ),
          subtitle: GoogleFonts.openSans(
              fontStyle: FontStyle.normal,
              fontSize: 12,
              textStyle: textTheme.subtitle),
          display1: GoogleFonts.roboto(
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              textStyle: textTheme.display1,
              fontSize: 30),
          display2: GoogleFonts.spartan(
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              textStyle: textTheme.display1,
              fontSize: 24),
          display3: GoogleFonts.robotoSlab(
              fontStyle: FontStyle.normal,
              color: Colors.black,
              textStyle: textTheme.display1,
              fontSize: 30),
          body1:
              GoogleFonts.openSans(fontStyle: FontStyle.normal, fontSize: 18)),
      cursorColor: ACCENT_COLOR);
}

class MyApp extends StatelessWidget {
  final Firestore firestore;

  MyApp(this.firestore);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rentcycle',
      theme: buildTheme(context).copyWith(brightness: Brightness.light),
      initialRoute: '/',
      routes: {
        '/requests': (context) => RequestListPage(firestore),
        '/requests/new': (context) => CreateRequestDetailsPage(firestore)
      },
      home: RequestListPage(firestore),
    );
  }
}
