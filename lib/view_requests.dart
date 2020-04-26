import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rentcycle/create_request.dart';
import 'package:rentcycle/view_request_details.dart';
import 'util.dart';

class RequestListPage extends StatefulWidget {
  final Firestore firestore;

  RequestListPage(this.firestore);

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
  OrderingMode orderingMode = OrderingMode.MOST_RECENT;

  StreamBuilder<QuerySnapshot> _getRequests() {
    CollectionReference stream = widget.firestore.collection('requests');
    Query query;
//        .where('user', isGreaterThan: currentUser)
//        .where('user', isLessThan: currentUser);
    if (orderingMode == OrderingMode.MOST_POINTS) {
      query = stream.orderBy("suggested_points", descending: true);
    } else if (orderingMode == OrderingMode.LEAST_POINTS) {
      query = stream.orderBy("suggested_points", descending: false);
    } else if (orderingMode == OrderingMode.LONGEST_DURATION) {
      query = stream.where("duration", isNull: true);
    } else if (orderingMode == OrderingMode.SHORTEST_DURATION) {
      query = stream.orderBy("duration").startAfter([null]);
    } else {
      query = stream.orderBy("created_at");
    }
    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Text("Loading..."); // todo make pretty
        final int messageCount = snapshot.data.documents.length;
        print("Data changed, loading $messageCount listings.");
        return new ListView.builder(
          key: UniqueKey(),
          itemCount: messageCount,
          itemBuilder: (_, int index) {
            final DocumentSnapshot document = snapshot.data.documents[index];
            UserRequest request = UserRequest(
              id: document.reference.path,
              title: document.data['title'],
              created_at: (document.data['created_at'] as Timestamp).toDate(),
              image_url: document.data['image_url'],
              description: document.data['description'],
              suggested_points: document.data['suggested_points'],
              user: (document.data['user'] as DocumentReference).documentID,
              address: document.data['address'],
              duration: document.data['duration'],
            );
            print(request.id);
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
            child: Text("Requests to buy")),
        const PopupMenuItem<OrderingMode>(
            value: OrderingMode.SHORTEST_DURATION,
            child: Text("Requests to rent")),
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

  RequestWidgetState(this._request);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: _request.getUser(widget.firestore),
        builder: (BuildContext context, AsyncSnapshot<User> user) {
          return GestureDetector(
              key: UniqueKey(),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RequestDetailsPage(widget.firestore, _request)));
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
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .display1)),
                          subtitle: Text(_request.title,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .title),
                          title: Text(
                              user.data != null ? "${user.data.name} is requesting" : "",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .subtitle),
                          trailing: showTiming()))));
        });
  }

  Widget showTiming() {
    if (_request.duration != null) {
      return
        Text("${_request.duration} hrs",
            style: Theme
                .of(context)
                .textTheme
                .display2);
    }

    return Icon(Icons.timer_off, size: 35);
  }
}
