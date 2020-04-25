class User {
  final int id;
  final String name;
  final String email;
  final String address;

  User(this.id, this.name, {this.email, this.address});
}

abstract class UserRequest {
  final int id;
  final String itemName;
  final int points;
  final DateTime postDate;

  List<int> hideFrom;

  User lender, receiver;

  UserRequest(this.id, this.itemName, this.points, this.receiver, this.postDate) {
    hideFrom = <int>[];
  }

  void fulfillRequest(User u); // accept a bounty (be willing to give)
  void acceptOffer(User u);
  void hideFromUser(User u) {
    if (!hideFrom.contains(u.id))
      hideFrom.add(u.id);
  }
}

class LendRequest extends UserRequest {
  final Duration lendFor;

  LendRequest(int id, String itemName, int points, User receiver, DateTime postDate, this.lendFor)
    : super(id, itemName, points, receiver, postDate);

  void fulfillRequest(User u) {

  }

  void acceptOffer(User u) {

  }
}

var users = [User(0, "Joe Test"), User(1, "Steven Debug")];
var userRequests = <UserRequest>[
  LendRequest(0, "Lawn Mower", 10, users[0], DateTime.now(), new Duration(hours: 6))
];

extension SortableList<T> on List<T> {
  List<T> sortBy(Comparable Function(T) fn) {
    sort((a, b) => fn(a).compareTo(fn(b)));
    return this;
  }
}