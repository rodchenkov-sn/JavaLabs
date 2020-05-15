class User {

  final String username;
  final String token;

  User({this.username, this.token});

  factory User.fromJson(Map<String, dynamic> json) => User(
    username: json['username'],
    token: json['token']
  );

}
