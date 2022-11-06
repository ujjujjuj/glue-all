class UserModel {
  String token;
  String userName;
  String? authId;

  get name => userName;

  UserModel({required this.token, required this.userName, this.authId});

  Map<String, dynamic> toJson() {
    return {'token': token, 'userName': userName, "authId": authId};
  }

  factory UserModel.fromJson({required Map<String, dynamic> json}) {
    return UserModel(
        token: json['token'],
        userName: json['userName'],
        authId: json['authId']);
  }
}
