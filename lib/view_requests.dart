import 'package:flutter/material.dart';
import 'package:rentcycle/create_request_title_page.dart';
import 'view_request_details.dart';
import 'util.dart';

class RequestListPage extends StatefulWidget {
  RequestListPage();

  @override
  RequestListState createState() => RequestListState();
}

enum OrderingMode {
  MOST_RECENT,
  MOST_POINTS,
  LEAST_POINTS,
  SHORTEST_DURATION,
  LONGEST_DURATION
}

class RequestListState extends State<RequestListPage> {
  List<UserRequest> _requests;
  OrderingMode orderingMode = OrderingMode.MOST_RECENT;

  RequestListState() {
    _getRequests();
  }

  @override
  Widget build(BuildContext _) {
    return Scaffold(
      appBar: AppBar(title: Text("Requests"), actions: <Widget>[
        IconButton(
            icon: Icon(Icons.add, color: BODY_COLOR),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateRequestTitlePage()));
            },
            tooltip: "Make Request")
      ]),
      body: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _requests.length,
          itemBuilder: (BuildContext bctx, int ndx) {
            var reqW = _requests[ndx];
            if (reqW.hideFrom.contains(currentUser.id)) return null;

            return RequestWidget(currentUser, reqW);
          }));
  }

  void _getRequests() {
    _requests = userRequests.where((x) => !x.hideFrom.contains(currentUser.id)).toList();
  }
}

class RequestWidget extends StatefulWidget {
  final User _user;
  final UserRequest _request;

  RequestWidget(this._user, this._request);

  @override
  State<StatefulWidget> createState() => RequestWidgetState(_request);
}

class RequestWidgetState extends State<RequestWidget> {
  UserRequest _request;

  RequestWidgetState(this._request);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RequestDetailsPage(_request)
            )
          );
        },
        child: Dismissible(
            key: Key(_request.id.toString()),
            onDismissed: (direction) {
              if (direction == DismissDirection.horizontal) {
                setState(() {
                  _request.hideFromUser(widget._user);
                });
              }
            },
            child: Card(
                elevation: 2.0,
                margin:
                    new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                    decoration: BoxDecoration(color: SECONDARY_BG_COLOR),
                    child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        leading: Container(
                            padding: EdgeInsets.only(right: 12.0),
                            decoration: new BoxDecoration(
                                border: new Border(
                                    right: new BorderSide(
                                        width: 1.0, color: BORDER_COLOR))),
                            child: Text(_request.pointsAvg.toString(),
                                style: Theme.of(context).textTheme.display1)),
                        title: Text(_request.itemName,
                            style: Theme.of(context).textTheme.title),
                        subtitle: Text("${_request.receiver.name}",
                            style: Theme.of(context).textTheme.subtitle),
                        trailing: showTiming())))));
  }

  Widget showTiming() {
    if (_request is LendRequest) {
      var ler = _request as LendRequest;

      return Column(children: <Widget>[
        Icon(Icons.timer, size: 30),
        Text("For ${ler.lendFor} Hours",
            style: Theme.of(context).textTheme.subtitle)
      ]);
    }

    return Icon(Icons.timer_off, size: 35);
  }
}
