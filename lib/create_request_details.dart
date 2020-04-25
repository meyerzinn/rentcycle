import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateRequestDetailsPage extends StatefulWidget {
  final String initialTitle;

  CreateRequestDetailsPage(@required this.initialTitle);

  @override
  _CreateRequestDetailsPageState createState() =>
      new _CreateRequestDetailsPageState(initialTitle);
}

class _CreateRequestDetailsPageState extends State<CreateRequestDetailsPage> {
  String _title;
  String _description;

  final _formKey = GlobalKey<FormState>();

  _CreateRequestDetailsPageState(String initialTitle) {
    this._title = initialTitle;
  }

  @override
  Widget build(BuildContext context) {
    final makeAppBar = AppBar(
      elevation: 0.1,
      title: Text("Request " + _title),
      actions: <Widget>[
        IconButton(

        ),
      ],

    );
    return Scaffold(

    );
  }
}
