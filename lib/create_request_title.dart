import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentcycle/create_request_details.dart';

class CreateRequestTitle extends StatefulWidget {
  @override
  _CreateRequestTitleState createState() => new _CreateRequestTitleState();
}

class _CreateRequestTitleState extends State<CreateRequestTitle> {
  String _title;

  void _continue(BuildContext context) {
    if (_title == "") return; // focus left the field while still empty, ignore
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CreateRequestDetailsPage(initialTitle: _title)));
  }

  void _updateInput(String newTitle) {
    setState(() {
      _title = newTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    var textStyle =
        GoogleFonts.spartan(fontSize: 24.0, fontStyle: FontStyle.normal);
    bool continueButtonVisible = _title != "";
    final makeContinueButton =
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      IgnorePointer(
        ignoring: _title == "",
        child: new Opacity(
          opacity: continueButtonVisible ? 1 : 0,
          child: new FlatButton(
              onPressed: () => _continue(context),
              child: Text(
                "CONTINUE",
                style: TextStyle(color: Colors.black),
              )),
        ),
      ),
    ]);
    final titleInputDecoration = InputDecoration(
      hintText: 'a miter saw',
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1.0),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1.0),
      ),
    );
    final makeTitleInput = Row(children: [
      Flexible(
        child: TextField(
          decoration: titleInputDecoration,
          textCapitalization: TextCapitalization.none,
          onChanged: _updateInput,
          onSubmitted: (String val) => _continue(context),
          autofocus: true,
          textInputAction: TextInputAction.go,
          style: textStyle,
          autocorrect: false,
          keyboardType: TextInputType.text,
          enableSuggestions: false,
        ),
      ),
    ]);
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(children: [
            Text(
              "I'd like",
              style: textStyle,
              textAlign: TextAlign.left,
            ),
          ]),
          makeTitleInput,
          makeContinueButton,
        ]);
  }
}
