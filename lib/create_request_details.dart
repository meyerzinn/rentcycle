import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rentcycle/util.dart';
import 'package:rentcycle/view_requests.dart';

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
                            // todo add the form values
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RequestListWidget(users[0])));
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
}

//class _CreateRequestDetailsPageState extends State<CreateRequestDetailsPage> {
//  int _currentStep = 0;
//  String _title;
//  int _duration = 2;
//  bool _indefinite = false;
//  String _address = "my address";
//  String _description = "";
//
//  FocusScopeNode _focusScopeNode = FocusScopeNode();
//  final _formKey = GlobalKey<FormState>();
//
//  void dispose() {
//    _focusScopeNode.dispose();
//    super.dispose();
//  }
//
//  _CreateRequestDetailsPageState(String initialTitle) {
//    this._title = initialTitle;
//  }
//
//  List<Step> _steps() {
//    return [
//      Step(
//        title: Text("I'd like" + (_currentStep != 0 ? " " + _title : "")),
//        content: TextFormField(
//          controller: TextEditingController(text: _title),
//          onChanged: (String newTitle) => setState(() => _title = newTitle),
//          autovalidate: true,
//          validator: (String value) {
//            return value.isEmpty ? "Please enter an item to request." : null;
//          },
//        ),
//        isActive: _currentStep >= 0,
//      ),
//      Step(
//        title: Text("for up to" +
//            (_currentStep != 1 ? " " + _duration.toString() + " hours" : "")),
//        content: Row(children: [
//          Flexible(
//              child: TextFormField(
//                autovalidate: true,
//                controller: TextEditingController(text: _duration.toString()),
//                keyboardType: TextInputType.number,
//                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
//                validator: (String value) {
//                  return int.tryParse(value) != null
//                      ? null
//                      : "Please enter a number.";
//                },
//                onChanged: (String value) =>
//                    setState(() => _duration = int.parse(value)),
//              )),
//          Text("hours, or"),
//          Checkbox(value:)
//        ]),
//        isActive: _currentStep >= 1,
//      ),
//      Step(
//        title: Text("near" + (_currentStep != 2 ? " " + _address + "." : "")),
//        content: Row(
//          children: [
//            Flexible(
//              child: TextFormField(
////                controller: TextEditingController(),
//                autovalidate: true,
//                validator: (value) {
//                  if (value.isEmpty || value == "") {
//                    return "Please enter your address.";
//                  }
//                  return null;
//                },
//                onChanged: (String value) => setState(() => {_address = value}),
//              ),
//            ),
//          ],
//        ),
//        isActive: _currentStep >= 2,
//      ),
//      Step(
//        title: Text(
//            "More details: " + (_currentStep != 3 ? " " + _description : "")),
//        content: Row(
//          children: [
//            Flexible(
//              child: TextFormField(
//                controller: TextEditingController(text: _description),
//                onChanged: (String value) =>
//                    setState(() => {_description = value}),
//              ),
//            ),
//          ],
//        ),
//        isActive: _currentStep >= 3,
//      ),
////      Step(title: Text(""))
//    ];
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final makeAppBar = AppBar(
//      elevation: 0.1,
//      title: Text("Request " + _title),
//      actions: <Widget>[
////        IconButton(),
//      ],
//    );
//    return Scaffold(
//      appBar: makeAppBar,
//      body: Form(
//        key: _formKey,
//        child: Stepper(
//          steps: _steps(),
//          type: StepperType.vertical,
//          onStepTapped: (int index) => setState(() => _currentStep = index),
//          onStepContinue: () {
//            setState(() {
//              if (this._currentStep < this
//                  ._steps()
//                  .length - 1) {
//                this._currentStep++;
//              }
//            });
//          },
//          currentStep: _currentStep,
//          controlsBuilder: (BuildContext context,
//              {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
//            return Row(children: [
//              FlatButton(
//                onPressed: onStepContinue,
//                child: const Text('CONTINUE'),
//              )
//            ]);
//          },
//        ),
//      ),
//    );
//  }
//}
