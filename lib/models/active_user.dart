class ActiveUser {
  String name;
  String username;
  String image;
  String id;
  bool active;

  ActiveUser({
    this.name,
    this.username,
    this.id,
    this.active,
    this.image,
  });

  ActiveUser.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? 'anonymous';
    username = json['username'];
    image = json['image'];
    id = json['id'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['username'] = this.username;
    data['image'] = this.image;
    data['id'] = this.id;
    data['active'] = this.active;
    return data;
  }

  @override
  String toString() {
    return 'name: $name, username: $username, id: $id';
  }

  bool operator ==(dynamic other) {
    return other != null &&
        other is ActiveUser &&
        this.username == other.username;
  }

  @override
  int get hashCode => super.hashCode;
}
