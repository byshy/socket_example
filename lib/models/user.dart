class User {
  UserInfo data;
  String token;

  User({this.data, this.token});

  User.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new UserInfo.fromJson(json['data']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['token'] = this.token;
    return data;
  }

  @override
  String toString() {
    return 'data: ${data.toString()}\ntoken: $token';
  }
}

class UserInfo {
  String name;
  String email;

  UserInfo({this.name, this.email});

  UserInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    return data;
  }

  @override
  String toString() {
    return 'name: $name, email: $email';
  }
}
