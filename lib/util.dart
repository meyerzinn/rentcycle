import 'dart:math';

import 'package:flutter/material.dart';

class User {
  final int id;
  final String name;
  final String email;
  final int balance;

  User(this.id, this.name, this.balance, {this.email});
}

class UserOffer {
  final String id;
  final String title;
  final int suggestedPoints;
  final bool buy;
  String imageURL;

  List<int> hideFrom = [];

  UserOffer(this.id, this.title, this.suggestedPoints, this.buy, this.imageURL);
}

abstract class UserRequest {
  final int id;
  final String itemName;
  final int suggestedPoints;
  final DateTime postDate;
  final String description;
  final String address;
  final String imageURL;

  List<int> hideFrom = [];
  Map<int, int> bids = {};

  User lender, receiver;

  UserRequest(this.id, this.itemName, this.suggestedPoints, this.receiver,
      this.postDate, this.description, this.address, this.imageURL);

  void fulfillRequest(User u); // accept a bounty (be willing to give)
  void acceptOffer(User u);

  void hideFromUser(User u) {
    if (!hideFrom.contains(u.id)) hideFrom.add(u.id);
  }

  get pointsAvg => bids.length == 0
      ? suggestedPoints
      : (bids.values.reduce(min) + suggestedPoints) ~/ 2;
}

class LendRequest extends UserRequest {
  final int lendFor;

  LendRequest(int id, String itemName, int points, User receiver,
      String description, String address, String imageURL, this.lendFor)
      : super(id, itemName, points, receiver, DateTime.now(), description,
            address, imageURL);

  void fulfillRequest(User u) {}

  void acceptOffer(User u) {}
}

class BuyRequest extends UserRequest {
  BuyRequest(int id, String itemName, int points, User receiver,
      String description, String address, String imageURL)
      : super(id, itemName, points, receiver, DateTime.now(), description,
            address, imageURL);

  void fulfillRequest(User u) {}

  void acceptOffer(User u) {}
}

var users = [User(0, "Joe Test", 200), User(1, "Steven Debug", 200)];
var userRequests = <UserRequest>[
  LendRequest(
      0,
      "Lawn Mower",
      10,
      users[0],
      "",
      "",
      "https://images.homedepot-static.com/productImages/c3adbfbf-c846-43b9-9baf-f797d9823e78/svn/john-deere-zero-turn-mowers-bg21150-64_1000.jpg",
      6)
];

var userOffers = <UserOffer>[
  UserOffer("1", "Leaf Blower", 5, false,
      "https://images-na.ssl-images-amazon.com/images/I/51gNQGs5d3L._AC_SX522_.jpg")
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
const ERROR_COLOR = Colors.red;
