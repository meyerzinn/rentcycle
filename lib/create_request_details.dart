import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateRequestDetailsPage extends StatefulWidget {
  final String initialTitle;

  CreateRequestDetailsPage(@required this.initialTitle);

  @override
  _CreateRequestDetailsPageState createState() =>
      new _CreateRequestDetailsPageState(initialTitle);
}

class _CreateRequestDetailsPageState extends State<CreateRequestDetailsPage> {
  int _currentStep = 0;
  String _title;
  int _duration = 2;
  String _address = "my address";
  String _description;

  FocusScopeNode _focusScopeNode = FocusScopeNode();
  final _formKey = GlobalKey<FormState>();

  void dispose() {
    _focusScopeNode.dispose();
    super.dispose();
  }

  _CreateRequestDetailsPageState(String initialTitle) {
    this._title = initialTitle;
  }

  List<Step> _steps() {
    return [
      Step(
        title: Text("I'd like" + (_currentStep != 0 ? " " + _title : "")),
        content: TextFormField(
          controller: TextEditingController(text: _title),
          onChanged: (String newTitle) => setState(() => _title = newTitle),
          autovalidate: true,
          validator: (String value) {
            return value.isEmpty ? "Please enter an item to request." : null;
          },
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: Text("for up to" +
            (_currentStep != 1 ? " " + _duration.toString() + " hours" : "")),
        content: Row(children: [
          Flexible(
              child: TextFormField(
            autovalidate: true,
            controller: TextEditingController(text: _duration.toString()),
            keyboardType: TextInputType.number,
            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            validator: (String value) {
              return int.tryParse(value) != null
                  ? null
                  : "Please enter a number.";
            },
            onChanged: (String value) =>
                setState(() => _duration = int.parse(value)),
          )),
          Text("hours"),
          Flexible(child: Container())
        ]),
      ),
      Step(
        title: Text("near" + (_currentStep != 2 ? " " + _address + "." : "")),
        content: Row(
          children: [
            Flexible(
              child: TextFormField(
//                controller: TextEditingController(),
                autovalidate: true,
                validator: (value) {
                  if (value.isEmpty || value == "") {
                    return "Please enter your address.";
                  }
                  return null;
                },
                onChanged: (String value) => setState(() => {_address = value}),
              ),
            ),
          ],
        ),
      ),
//      Step(title: Text(""))
    ];
  }

  @override
  Widget build(BuildContext context) {
    final makeAppBar = AppBar(
      elevation: 0.1,
      title: Text("Request " + _title),
      actions: <Widget>[
//        IconButton(),
      ],
    );
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stepper(
          steps: _steps(),
          type: StepperType.vertical,
          onStepTapped: (int index) => setState(() => _currentStep = index),
          onStepContinue: () {
            setState(() {
              if (this._currentStep < this._steps().length - 1) {
                this._currentStep++;
              }
            });
          },
          currentStep: _currentStep,
          controlsBuilder: (BuildContext context,
              {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
            return Row(children: [
              FlatButton(
                onPressed: onStepContinue,
                child: const Text('CONTINUE'),
              )
            ]);
          },
        ),
      ),
    );
  }
}
