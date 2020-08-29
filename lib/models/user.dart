class User {
  UserInfo data;
  String token;
  String errorMessage;

  User({
    this.data,
    this.token,
    this.errorMessage,
  });

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
  String username;
  String email;
  String image;

  UserInfo({
    this.name,
    this.username,
    this.email,
    this.image,
  });

  UserInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    username = json['username'];
    email = json['email'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['image'] = this.image;
    return data;
  }

  @override
  String toString() {
    return 'name: $name, username: $username, email: $email, image: $image';
  }
}
