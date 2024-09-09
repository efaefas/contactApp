
class UserModel {
  String? id;
  String? createdAt;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? profileImageUrl;

  UserModel(
      {this.id,
        this.createdAt,
        this.firstName,
        this.lastName,
        this.phoneNumber,
        this.profileImageUrl});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phoneNumber = json['phoneNumber'];
    profileImageUrl = json['profileImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['phoneNumber'] = phoneNumber;
    data['profileImageUrl'] = profileImageUrl;
    return data;
  }

  String get initials => firstName?.isNotEmpty == true ? firstName!.trim().split(' ').map((l) => l[0]).take(2).join() : '';

  static UserModel fromJsonModel(Map<String, dynamic> json) => UserModel.fromJson(json);

  static List<UserModel> fromJsonListModel(List<dynamic> json) {
    var list = <UserModel>[];
    for (var v in json) {
      list.add(UserModel.fromJson(v));
    }
    return list;
  }
}
