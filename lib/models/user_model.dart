class UserModel {
  String? username;
  String? email;
  String? password;
  String? phone;
  String? imageUrl;

  UserModel({this.username, this.email, this.password,this.phone,this.imageUrl});

  UserModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['email'] = email;
    data['password'] = password;
    data['phone'] = phone;
    data['imageUrl'] = imageUrl;
    return data;
  }
}
