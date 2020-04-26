import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  final String id;
  final String name;
  final int balance;

  User(this.id, this.name, this.balance);

  Future<List<String>> getHiddenRequests(Firestore firestore) async {
    var fut = await firestore.document(id).get();
    return fut.data['hidden_requests'];
  }

  static Future<User> get(Firestore firestore, String id) async {
    var fut = await firestore.document(id).get();
    return User(
        fut.documentID, await fut.data['name'], await fut.data['balance']);
  }
}

class UserOffer {
  final String id;
  final String title;
  final int suggestedPoints;
  final bool buy;
  String imageURL;

  UserOffer(this.id, this.title, this.suggestedPoints, this.buy, this.imageURL);
}

class Bid {
  final String id;
  final String user;
  final int amount;

  Bid({this.id, this.user, this.amount});
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

  Future<User> getUser(Firestore firestore) async {
    return User.get(firestore, '/users/' + user);
  }

  void hide(Firestore firestore) async {
    await firestore.document(currentUser).updateData({
      'hidden_requests': FieldValue.arrayUnion([id])
    });
  }

  Stream<QuerySnapshot> getBids(Firestore firestore) {
    return firestore.document(id).collection('bids').snapshots();
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
