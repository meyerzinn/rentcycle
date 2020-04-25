import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentcycle/create_request_title.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => new _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  @override
  Widget build(BuildContext context) {
    // TODO: add thing at the bottom to skip onboarding
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new Padding(
        padding: EdgeInsets.all(16),
        child: CreateRequestTitle(),
      ),
    );
    return null;
  }
}
