/*import 'package:flutter/material.dart';
import 'package:rentcycle/create_request_title_page.dart';
import 'util.dart';

class OffersListPage extends StatefulWidget {
  OffersListPage();

  @override
  OffersListPage createState() => OffersListPageState();
}

class _OffersListPageState extends State<OffersListPage> {
  List<UserOffer> _offers;

  void _refresh() {
    // TODO connect firestore later
    _offers = _getOffers();
  }

  @override
  Widget build(BuildContext _) {
    if (_offers == null) _offers = _getOffers();

    return Scaffold(
      appBar: AppBar(title: Text("Offers"), actions: <Widget>[
        IconButton(
            icon: Icon(Icons.add, color: BODY_COLOR),
            onPressed: () {
              // TODO redirect to Meyer's page
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateRequestTitlePage()));
            },
            tooltip: "Make Request"),
      ]),
      body: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _offers.length,
          itemBuilder: (BuildContext bctx, int ndx) {
            var offW = _offers[ndx];
            if (offW.hideFrom.contains(widget.user.id)) return null;

            return RequestWidget(offW);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _refresh,
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
        backgroundColor: ACCENT_COLOR,
      ),
    );
  }

  List<UserOffer> _getOffers() =>
      _sortByOrdering(
          userR.where((x) => !x.hideFrom.contains(widget.user.id)).toList());

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

  List<UserRequest> _sortByOrdering(List<UserRequest> requests) {
    switch (orderingMode) {
      case OrderingMode.LEAST_POINTS:
        return requests
            .sortBy((x) => x.suggestedPoints)
            .reversed
            .toList();
      case OrderingMode.MOST_POINTS:
        return requests.sortBy((x) => x.suggestedPoints);
      case OrderingMode.SHORTEST_DURATION:
        return requests.sortBy((x) {
          if (x is LendRequest) return x.lendFor.inMinutes;

          return double.infinity;
        });
      case OrderingMode.LONGEST_DURATION:
        return requests
            .sortBy((x) {
          if (x is LendRequest) return x.lendFor.inMinutes;

          return double.infinity;
        })
            .reversed
            .toList();
      case OrderingMode.MOST_RECENT:
        return requests
            .sortBy((x) =>
        DateTime
            .now()
            .difference(x.postDate)
            .inMinutes);
    }
  }
}

class OfferWidget extends StatefulWidget {
  final User _user;
  final UserRequest _request;

  OfferWidget(this._user, this._request);

  @override
  State<StatefulWidget> createState() => _OfferWidgetState(_request);
}

class _OfferWidgetState extends State<OfferWidget> {
  UserRequest _request;

  _OfferWidgetState(this._request);

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
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .display1)),
                      title: Text(_request.itemName,
                          style: Theme
                              .of(context)
                              .textTheme
                              .title),
                      subtitle: Text("${_request.receiver.name}",
                          style: Theme
                              .of(context)
                              .textTheme
                              .subtitle),
    )))));
  }
}*/
