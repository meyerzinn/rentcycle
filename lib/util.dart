import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  final String id;
  final String name;
  final int balance;

  User(this.id, this.name, this.balance);
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
    return User(fut.documentID, await fut.data['name'], await fut.data['balance']);
  }

//  get pointsAvg => bids.length == 0
//      ? suggested_points
//      : (bids.reduce(min) + suggested_points) ~/ 2;
}

var currentUser = '/users/IwxlXa9pzJkRMPItie6z';

// COLORS
const ACCENT_COLOR = Colors.greenAccent;
const BODY_COLOR = Colors.black;
const MAIN_BG_COLOR = Colors.white;
const SECONDARY_BG_COLOR = Colors.white70;
const BORDER_COLOR = Colors.grey;
