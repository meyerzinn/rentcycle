import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentcycle/create_request_title.dart';

class CreateRequestTitlePage extends StatefulWidget {
  @override
  _CreateRequestTitlePageState createState() => new _CreateRequestTitlePageState();
}

class _CreateRequestTitlePageState extends State<CreateRequestTitlePage> {

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
