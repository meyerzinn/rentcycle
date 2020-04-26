import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'util.dart';
import 'view_requests.dart';

class RequestDetailsPage extends StatefulWidget {
  final Firestore firestore;
  final UserRequest request;

  RequestDetailsPage(this.firestore, this.request);

  @override
  RequestDetailsState createState() => RequestDetailsState();
}

class RequestDetailsState extends State<RequestDetailsPage> {
  User user;

  @override
  void initState() {
    widget.request.getUser(widget.firestore).then(
        (user) => setState(() { this.user = user; } )
    );
  }

  @override
  Widget build(BuildContext bctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.request.title)
      ),
      body: Container(
        margin: new EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: new EdgeInsets.only(bottom: 10),
              child: Row(children: <Widget>[
                Text("By: ", style: Theme.of(bctx).textTheme.title),
                Text(user != null ? user.name : "", style: Theme.of(bctx).textTheme.body1)
              ]),
            ),
            Container(
                alignment: Alignment.centerLeft,
                child: makeDescription(bctx)
            ),
          ]
        )
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          margin: new EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                child: Text("Make an offer", style: Theme.of(bctx).textTheme.button),
                color: ACCENT_COLOR,
                onPressed: () {
                  showDialog(
                      context: bctx,
                      builder: (context) => Dialog(
                        child: BidPopupWidget(widget.firestore, widget.request)
                      )
                  );
                },
              ),
              RaisedButton(
                child: Text("Ignore", style: Theme.of(bctx).textTheme.button),
                color: Theme.of(context).buttonColor,
                onPressed: () {
                  widget.request.hide(widget.firestore);
                  Navigator.pushReplacement(bctx,
                      MaterialPageRoute(builder: (context) => RequestListPage(widget.firestore))
                  );
                },
              )
            ],
          )
        )
      ),
    );
  }

  Widget makeDescription(BuildContext bctx) {
    if (widget.request.description == "") {
      return Text("No description provided",
          style: Theme.of(bctx).textTheme.body2.copyWith(
            fontStyle: FontStyle.italic
          ));
    }
    else {
      return Text(widget.request.description, style: Theme.of(bctx).textTheme.body2);
    }
  }
}

class BidPopupWidget extends StatefulWidget {
  final UserRequest request;
  final Firestore firestore;

  BidPopupWidget(this.firestore, this.request);

  @override
  BidPopupState createState() => BidPopupState();
}

class BidPopupState extends State<BidPopupWidget> {
  int bid = 0;
  bool bidValid = false;
  FocusNode fnode = new FocusNode();

  @override
  Widget build(BuildContext bctx) {
    return Container(
      margin: new EdgeInsets.all(10),
      constraints: BoxConstraints(maxHeight: 200),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "Bid:",
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ACCENT_COLOR)
                ),
                labelStyle: TextStyle(
                  color: fnode.hasFocus ? ACCENT_COLOR : BODY_COLOR
                )
              ),
              focusNode: fnode,
              autovalidate: true,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly
              ],
              validator: (value) {
                if (value == "") {
                  bidValid = false;
                  return "You must input a bid.";
                }

                var p = int.tryParse(value);

                if (p == null) {
                  bidValid = false;
                  return "Value must be an integer";
                }
                else if (p < 1) {
                  bidValid = false;
                  return "Bid must be a positive number.";
                }
                else {
                  bidValid = true;
                  return null;
                }
              },
              onChanged: (String value) {
                if (!bidValid)
                  return;

                setState(() {
                  bid = int.parse(value);
                });
              },
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                child: Text("Confirm"),
                onPressed: bidValid ? () => _doBid(bctx) : null
              ),
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(bctx).pop();
                },
              )
            ],
          )
          
        ],
      )
    );
  }

  void _doBid(bctx) {
    /*widget.request.bids[currentUser.id] = bid;
    Navigator.of(bctx).pop();

    widget.request.hideFromUser(currentUser);
    Navigator.pushReplacement(bctx,
      MaterialPageRoute(
          builder: (bctx) => RequestListPage(widget.firestore,)
      )
    );*/
  }
}


