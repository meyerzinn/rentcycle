import 'dart:math';

import 'package:flutter/material.dart';

class User {
  final int id;
  final String name;
  final String email;

  User(this.id, this.name, {this.email});
}

abstract class UserRequest {
  final int id;
  final String itemName;
  final int suggestedPoints;
  final DateTime postDate;
  final String description;
  final String address;

  List<int> hideFrom;
  List<int> bids;

  User lender, receiver;

  UserRequest(this.id, this.itemName, this.suggestedPoints, this.receiver, this.postDate, this.description, this.address) {
    hideFrom = <int>[];
    bids = <int>[];
  }

  void fulfillRequest(User u); // accept a bounty (be willing to give)
  void acceptOffer(User u);

  void hideFromUser(User u) {
    if (!hideFrom.contains(u.id))
      hideFrom.add(u.id);
  }

  get pointsAvg => bids.length == 0 ? suggestedPoints : (bids.reduce(min) + suggestedPoints) ~/ 2;
}

class LendRequest extends UserRequest {
  final int lendFor;

  LendRequest(int id, String itemName, int points, User receiver, String description, String address, this.lendFor)
    : super(id, itemName, points, receiver, DateTime.now(), description, address);

  void fulfillRequest(User u) {

  }

  void acceptOffer(User u) {

  }
}

class BuyRequest extends UserRequest {
  BuyRequest(int id, String itemName, int points, User receiver, String description, String address)
    : super(id, itemName, points, receiver, DateTime.now(), description, address);

  void fulfillRequest(User u) {

  }

  void acceptOffer(User u) {

  }
}

var users = [User(0, "Joe Test"), User(1, "Steven Debug")];
var userRequests = <UserRequest>[
  LendRequest(0, "Lawn Mower", 10, users[0], "", "", 6)
];

extension SortableList<T> on List<T> {
  List<T> sortBy(Comparable Function(T) fn) {
    sort((a, b) => fn(a).compareTo(fn(b)));
    return this;
  }
}

var currentUser = users[1];

// COLORS
const ACCENT_COLOR = Colors.greenAccent;
const BODY_COLOR = Colors.black;
const MAIN_BG_COLOR = Colors.white;
const SECONDARY_BG_COLOR = Colors.white70;
const BORDER_COLOR = Colors.grey;