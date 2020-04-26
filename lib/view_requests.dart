import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rentcycle/create_request.dart';
import 'util.dart';

class RequestListWidget extends StatefulWidget {
  final Firestore firestore;

  RequestListWidget(this.firestore);

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

class RequestListState extends State<RequestListWidget> {
  OrderingMode orderingMode = OrderingMode.MOST_RECENT;

  StreamBuilder<QuerySnapshot> _getRequests() {
    dynamic stream = widget.firestore.collection('/requests');
    if (orderingMode == OrderingMode.MOST_POINTS) {
      stream = stream.orderBy("suggested_points", descending: true);
    } else if (orderingMode == OrderingMode.LEAST_POINTS) {
      stream = stream.orderBy("suggested_points", descending: false);
    } else if (orderingMode == OrderingMode.LONGEST_DURATION) {
      stream = stream.orderBy("duration", descending: true);
    } else if (orderingMode == OrderingMode.SHORTEST_DURATION) {
      stream = stream.orderBy("duration", descending: false);
    } else if (orderingMode == OrderingMode.MOST_RECENT) {
      stream = stream.orderBy("created_at", descending: true);
    }
    return StreamBuilder<QuerySnapshot>(
      stream: stream.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Text("Loading..."); // todo make pretty
        final int messageCount = snapshot.data.documents.length;
        return ListView.builder(
          itemCount: messageCount,
          itemBuilder: (_, int index) {
            final DocumentSnapshot document = snapshot.data.documents[index];
            UserRequest request = UserRequest(
              id: document.documentID,
              title: document.data['title'],
              created_at: (document.data['created_at'] as Timestamp).toDate(),
              image_url: document.data['image_url'],
              description: document.data['description'],
              suggested_points: document.data['suggested_points'] as int,
              user: document.data['user'],
              address: document.data['address'],
              duration: document.data['duration'] != null ? int.tryParse(document.data['duration']) : null,
            );
            return RequestWidget(widget.firestore, request);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext _) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Requests"), actions: <Widget>[
        IconButton(
            icon: Icon(Icons.add, color: BODY_COLOR),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CreateRequestDetailsPage(widget.firestore)));
            },
            tooltip: "Make Request"),
        PopupMenuButton(
          icon: Icon(Icons.sort, color: BODY_COLOR),
          onSelected: (OrderingMode result) {
            setState(() {
              orderingMode = result;
            });
          },
          itemBuilder: _buildSortPopup,
          tooltip: "Select Ordering",
        )
      ]),
      body: _getRequests(),
//        ListView.builder(
//            scrollDirection: Axis.vertical,
//            shrinkWrap: true,
//            itemCount: _requests.length,
//            itemBuilder: (BuildContext bctx, int ndx) {
//              var reqW = _requests[ndx];
//              if (reqW.hideFrom.contains(currentUser.id)) return null;
//
//              return RequestWidget(currentUser, reqW);
//            }));
    );
  }

  List<PopupMenuEntry<OrderingMode>> _buildSortPopup(BuildContext bctx) =>
      <PopupMenuEntry<OrderingMode>>[
        const PopupMenuItem<OrderingMode>(
            value: OrderingMode.MOST_RECENT, child: Text("Most Recent")),
        const PopupMenuItem<OrderingMode>(
            value: OrderingMode.LEAST_POINTS, child: Text("Least Points")),
        const PopupMenuItem<OrderingMode>(
            value: OrderingMode.MOST_POINTS, child: Text("Most Points")),
        const PopupMenuItem<OrderingMode>(
            value: OrderingMode.LONGEST_DURATION,
            child: Text("Longest Duration")),
        const PopupMenuItem<OrderingMode>(
            value: OrderingMode.SHORTEST_DURATION,
            child: Text("Shortest Duration")),
      ];
}

class RequestWidget extends StatefulWidget {
  final Firestore firestore;
  final UserRequest _request;

  RequestWidget(this.firestore, this._request);

  @override
  State<StatefulWidget> createState() => RequestWidgetState(_request);
}

class RequestWidgetState extends State<RequestWidget> {
  final UserRequest _request;
  String userName = "";

  RequestWidgetState(this._request);

  @override
  void initState() {
    _request
        .getUser(widget.firestore)
        .then((User user) => setState(() => userName = user.name));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // TODO open request
          print("test");
        },
        child: Dismissible(
            key: Key(_request.id.toString()),
            onDismissed: (direction) {
              if (direction == DismissDirection.horizontal) {
                setState(() {
                  _request.hide();
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
                            child: Text(_request.suggested_points.toString(),
                                style: Theme.of(context).textTheme.display1)),
                        title: Text(_request.title,
                            style: Theme.of(context).textTheme.title),
                        subtitle: Text(userName,
                            style: Theme.of(context).textTheme.subtitle),
                        trailing: showTiming())))));
  }

  Widget showTiming() {
    if (_request.duration != null) {
      return Column(children: <Widget>[
        Icon(Icons.timer, size: 30),
        Text("For ${_request.duration} Hours",
            style: Theme.of(context).textTheme.subtitle)
      ]);
    }

    return Icon(Icons.timer_off, size: 35);
  }
}
