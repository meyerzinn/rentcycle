import 'package:flutter/material.dart';
import 'util.dart';

class RequestListWidget extends StatefulWidget {
  final User user;

  RequestListWidget(this.user);

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
  List<UserRequest> _requests;
  OrderingMode orderingMode = OrderingMode.MOST_RECENT;

  void _refresh() {
    // TODO connect firestore later
    _requests = _getRequests();
  }

  @override
  Widget build(BuildContext _) {
    if (_requests == null)
      _requests = _getRequests();

    return Scaffold(
      appBar: AppBar(
        title: Text("Requests"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              // TODO redirect to Meyer's page
            },
          ),
          PopupMenuButton(
            icon: Icon(Icons.sort, color: Colors.white),
            onSelected: (OrderingMode result) { setState(() {
              orderingMode = result;
              _requests = _getRequests();
            }); },
            itemBuilder: _buildSortPopup
          )
        ]
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _requests.length,
        itemBuilder: (BuildContext bctx, int ndx) {
          var reqW = _requests[ndx];
          if (reqW.hideFrom.contains(widget.user.id))
            return null;

          return RequestWidget(widget.user, reqW);
        }

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refresh,
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
        backgroundColor: Colors.greenAccent,
      ),
    );
  }

  List<UserRequest> _getRequests() => _sortByOrdering(
      userRequests
      .where((x) => !x.hideFrom.contains(widget.user.id)).toList()
      );

  List<PopupMenuEntry<OrderingMode>> _buildSortPopup(BuildContext bctx)
    => <PopupMenuEntry<OrderingMode>>[
      const PopupMenuItem<OrderingMode>(
        value: OrderingMode.MOST_RECENT,
        child: Text("Most Recent")
      ),
      const PopupMenuItem<OrderingMode>(
          value: OrderingMode.LEAST_POINTS,
          child: Text("Least Points")
      ),
      const PopupMenuItem<OrderingMode>(
          value: OrderingMode.MOST_POINTS,
          child: Text("Most Points")
      ),
      const PopupMenuItem<OrderingMode>(
          value: OrderingMode.LONGEST_DURATION,
          child: Text("Longest Duration")
      ),
      const PopupMenuItem<OrderingMode>(
          value: OrderingMode.SHORTEST_DURATION,
          child: Text("Shortest Duration")
      ),
    ];

  List<UserRequest> _sortByOrdering(List<UserRequest> requests) {
    switch (orderingMode) {
      case OrderingMode.LEAST_POINTS:
        return requests.sortBy((x) => x.points).reversed.toList();
      case OrderingMode.MOST_POINTS:
        return requests.sortBy((x) => x.points);
      case OrderingMode.SHORTEST_DURATION:
        return requests.sortBy((x) {
          if (x is LendRequest)
            return (x as LendRequest).lendFor.inMinutes;

          return double.infinity;
        });
      case OrderingMode.LONGEST_DURATION:
        return requests.sortBy((x) {
          if (x is LendRequest)
            return (x as LendRequest).lendFor.inMinutes;

          return double.infinity;
        }).reversed.toList();
      case OrderingMode.MOST_RECENT:
        return requests.sortBy((x) => DateTime.now().difference(x.postDate).inMinutes);
    }
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
        // TODO open request
        print("test");
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
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          child: Container(
            decoration: BoxDecoration(color: Colors.white70),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: Container(
                  padding: EdgeInsets.only(right: 12.0),
                  decoration: new BoxDecoration(
                      border: new Border(
                          right: new BorderSide(width: 1.0, color: Colors.grey)
                      )
                  ),
                  child: Text(_request.points.toString(), style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                      fontSize: 35
                  ))
              ),
              title: Text(_request.itemName, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22)),
              subtitle: Text("${_request.receiver.name}"),
              trailing: showTiming()
            )
          )
        )
      )
    );
  }

  Widget showTiming() {
    if (_request is LendRequest) {
      var ler = _request as LendRequest;

      return Column(
        children: <Widget>[
          Icon(Icons.timer, size: 30),
          Text("For ${ler.lendFor.inHours}:${(ler.lendFor.inMinutes % 60).toString()
              .padLeft(2, '0')}")
        ]
      );
    }

    return Icon(Icons.timer_off, size: 35);
  }
}
