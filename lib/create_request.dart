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
    final titleInputDecoration = InputDecoration(
      hintText: 'a miter saw',
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1.0),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1.0),
      ),
    );
    final appBar = AppBar(
      backgroundColor: Theme.of(context).appBarTheme.color,
      brightness: Brightness.light,
      title:
          Text("Create a request", style: Theme.of(context).textTheme.headline),
    );
    var style = Theme.of(context).textTheme.title;
    return Scaffold(
        appBar: appBar,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(children: [
                    Text("I'd like", style: style),
                  ]),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          controller: TextEditingController(text: title),
                          onChanged: (String newTitle) =>
                              setState(() => title = newTitle),
                          autovalidate: true,
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
                        autovalidate: true,
                        controller:
                            TextEditingController(text: duration.toString()),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        validator: (String value) {
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
                  Row(children: [
                    Text("Suggested points: ", style: style),
                    Container(
                      width: 8,
                    ),
                    Flexible(
                        child: TextFormField(
                      autovalidate: true,
                      controller: TextEditingController(
                          text: suggested_points.toString()),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      validator: (String value) {
                        return int.tryParse(value) != null
                            ? null
                            : "Please enter a number.";
                      },
                      onChanged: (String value) =>
                          setState(() => suggested_points = int.parse(value)),
                    )),
                    Flexible(
                      child: Container(),
                      flex: 4,
                    )
                  ]),
                  Container(height: 12),
                  Row(
                    children: <Widget>[
                      Text("Any more details?", style: style),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(child: TextFormField(
                        onChanged: (String value) {
                          setState(() {
                            description = value;
                          });
                        },
                      ))
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
                                    builder: (context) => RequestListWidget(widget.firestore)));
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
      "user": currentUser,
      "address": address,
      "created_at": FieldValue.serverTimestamp(),
      "description": description,
      "duration": buy ? null : duration,
      "image_url": null,
      "suggested_points": 10, //todo
      "title": title,
    });
//    int id = new Random().nextInt(1 << 16);
//
//    if (buy) {
//      return BuyRequest(
//        id, title, 10, currentUser, description, address, "",
//      );
//    }
//    else {
//      return LendRequest(
//        id, title, 10, currentUser, description, address, "", duration
//      );
//    }
  }
}
