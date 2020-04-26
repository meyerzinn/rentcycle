import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  final String id;
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

//  List<int> hideFrom = [];

  UserOffer(this.id, this.title, this.suggestedPoints, this.buy, this.imageURL);
}

class UserRequest {
  final String id;
  final String user;
  final String title;
  final int suggested_points;
  final DateTime created_at;
  final String description;
  final String address;
  final String image_url;
  final int duration;

  bool hidden = false;

  UserRequest(
      {this.id,
      this.user,
      this.title,
      this.suggested_points,
      this.created_at,
      this.description,
      this.address,
      this.image_url,
      this.duration});

  void hide() {
    hidden = true;
  }

  Future<User> getUser(Firestore firestore) async {
    var fut = await firestore.document(user).get();
    return User(fut.documentID, await fut.data['name']);
  }

//  get pointsAvg => bids.length == 0
//      ? suggested_points
//      : (bids.reduce(min) + suggested_points) ~/ 2;
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

var currentUser = '/users/IwxlXa9pzJkRMPItie6z';

// COLORS
const ACCENT_COLOR = Colors.greenAccent;
const BODY_COLOR = Colors.black;
const MAIN_BG_COLOR = Colors.white;
const SECONDARY_BG_COLOR = Colors.white70;
const BORDER_COLOR = Colors.grey;
const ERROR_COLOR = Colors.red;
