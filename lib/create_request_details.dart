import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rentcycle/util.dart';
import 'package:rentcycle/view_requests.dart';

import 'dart:math';

class CreateRequestDetailsPage extends StatefulWidget {
  final String initialTitle;

  CreateRequestDetailsPage({this.initialTitle});

  @override
  _CreateRequestDetailsPageState createState() =>
      new _CreateRequestDetailsPageState(title: initialTitle);
}

class _CreateRequestDetailsPageState extends State<CreateRequestDetailsPage> {
  String title;
  int duration = 2;
  bool buy = false;
  String address = "";
  String description = "";

  final _formKey = GlobalKey<FormState>();

  _CreateRequestDetailsPageState(
      {@required this.title,
      this.duration = 2,
      this.buy = false,
      this.address = "",
      this.description = ""});

  @override
  Widget build(BuildContext context) {
//    print();
    final appBar = AppBar(
      backgroundColor: Theme.of(context).appBarTheme.color,
      brightness: Brightness.light,
//      elevation: 0,
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
                  Row(
                    children: <Widget>[Text("I'd like", style: style)],
                  ),
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
                    Flexible(child: Container(), flex: 2),
                    Text("or", style: style),
                    Flexible(child: Container(), flex: 2),
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
                            var userReq = _makeUserReq();
                            userRequests.add(userReq);

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RequestListWidget()));
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

  UserRequest _makeUserReq() {
    int id = new Random().nextInt(1 << 16);

    if (buy) {
      return BuyRequest(
        id, title, 10, currentUser, description, address, "",
      );
    }
    else {
      return LendRequest(
        id, title, 10, currentUser, description, address, "", duration
      );
    }
  }
}
