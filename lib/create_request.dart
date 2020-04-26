import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rentcycle/util.dart';
import 'package:rentcycle/view_requests.dart';

import 'dart:math';

class CreateRequestDetailsPage extends StatefulWidget {
  final Firestore firestore;

  CreateRequestDetailsPage(this.firestore);

  @override
  _CreateRequestDetailsPageState createState() =>
      new _CreateRequestDetailsPageState();
}

class _CreateRequestDetailsPageState extends State<CreateRequestDetailsPage> {
  String title;
  int duration = 2;
  bool buy = false;
  String address = "";
  String description;
  int suggested_points = 10;

  final _formKey = GlobalKey<FormState>();

  _CreateRequestDetailsPageState(
      {this.title,
      this.duration = 2,
      this.buy = false,
      this.address = "",
      this.description = ""});

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: Theme.of(context).appBarTheme.color,
      brightness: Brightness.light,
      title: Text("Create a request"),
    );
    var style = Theme.of(context).textTheme.display3;
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: appBar,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Image(
                      image: AssetImage("assets/logo_no_text.png"),
                      height: 128,
                    )
                  ]),
                  Container(height: 24),
                  Row(children: [
                    Text("I'd like", style: style),
                  ]),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          style: Theme.of(context).textTheme.body1,
                          decoration: InputDecoration(
                            hintText: 'a miter saw',
                          ),
                          onChanged: (String newTitle) =>
                              setState(() => title = newTitle),
                          validator: (String value) {
                            return value.isEmpty
                                ? "Please enter an item to request."
                                : null;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(children: [
                    Text("for at least", style: style),
                    Container(width: 8),
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        style: Theme.of(context).textTheme.body1,
                        decoration: InputDecoration(
                          hintText: "2",
                        ),
                        validator: (String value) {
                          if (buy) return null;
                          return int.tryParse(value) != null
                              ? null
                              : "Please enter a number.";
                        },
                        onChanged: (String value) =>
                            setState(() => duration = int.parse(value)),
                        enabled: !buy,
                      ),
                    ),
                    Text("hours", style: style),
                  ]),
                  Row(children: [
                    Flexible(child: Container()),
                    Text("or", style: style),
                    Checkbox(
                      value: buy,
                      tristate: false,
                      onChanged: (val) => setState(() {
                        buy = val;
                      }),
                    ),
                    Text("buy it", style: style),
                  ]),
                  Row(children: [
                    Text("near", style: style),
                    Container(width: 8),
                    Flexible(
                      child: TextFormField(
                        style: Theme.of(context).textTheme.body1,
                        decoration: InputDecoration(hintText: "my address"),
                        validator: (value) {
                          if (value.isEmpty || value == "") {
                            return "Please enter your address.";
                          }
                          return null;
                        },
                        onChanged: (String value) =>
                            setState(() => {address = value}),
                      ),
                    ),
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Text("Suggested points: ", style: style),
                    Container(
                      width: 8,
                    ),
                    Flexible(
                        child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      validator: (String value) {
                        return int.tryParse(value) != null ? null : "";
                      },
                      decoration: InputDecoration(hintText: "10"),
                      style: Theme.of(context).textTheme.body1,
                      onChanged: (String value) =>
                          setState(() => suggested_points = int.parse(value)),
                    ))
                  ]),
                  Container(height: 12),
                  Row(
                    children: <Widget>[
                      Text("Any more details?", style: style),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                          child: TextFormField(
                              onChanged: (String value) {
                                setState(() {
                                  description = value;
                                });
                              },
                              style: Theme.of(context).textTheme.body1))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _createUserRequest();

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RequestListPage(widget.firestore)));
                          } else {
                            print("invalid form");
                          }
                        },
                        child: const Text('CONTINUE'),
                      )
                    ],
                  )
                ],
              ),
            )));
  }

  UserRequest _createUserRequest() {
    widget.firestore.collection('/requests').document().setData({
      "user": widget.firestore.document(currentUser),
      "address": address,
      "created_at": FieldValue.serverTimestamp(),
      "description": description,
      "duration": buy ? null : duration,
      "image_url": null,
      "suggested_points": suggested_points, //todo
      "title": title,
    });
  }
}
