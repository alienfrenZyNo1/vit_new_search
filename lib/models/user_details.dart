import 'dart:math';

class UserDetails {
  //final int id;
  final String firstName, lastName, email, unid;
  var rng = Random();
  final String profileUrl;

  UserDetails(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.unid,
      required this.profileUrl});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      firstName: json['first_name'] ?? "",
      lastName: json['last_name'] ?? "",
      email: json['email'] ?? "",
      unid: json['@unid'] ?? "",
      profileUrl:
          ("https://i.pravatar.cc/300?img=" + Random().nextInt(50).toString()),
    );
  }
}
