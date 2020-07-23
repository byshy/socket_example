class ActiveUser {
  String name;
  String email;
  String id;
  bool active;

  ActiveUser({this.name, this.email, this.id, this.active});

  ActiveUser.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? 'anonymous';
    email = json['email'];
    id = json['id'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['id'] = this.id;
    data['active'] = this.active;
    return data;
  }

  @override
  String toString() {
    return 'name: $name, email: $email';
  }
}
