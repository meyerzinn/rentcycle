class User {
  final int id;
  final String name;
  final String email;
  final String address;

  User(this.id, this.name, {this.email, this.address});
}

abstract class Bounty {
  final String itemName;

  User lender, receiver;

  Bounty(this.itemName, this.receiver);

  void acceptBounty(User u); // accept a bounty (be willing to give)
  void acceptOffer(User u);
}

class LendBounty extends Bounty {
  final DateTime lendFor;

  LendBounty(String itemName, User receiver, this.lendFor)
    : super(itemName, receiver);

  void acceptBounty(User u) {

  }

  void acceptOffer(User u) {

  }
}

var users = [User(0, "Joe Test"), User(1, "Steven Debug")];
var bounties = <Bounty>[];