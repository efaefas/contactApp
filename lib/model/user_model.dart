import 'package:get_storage/get_storage.dart';
import 'package:mobile/model/local_flag.dart';


class UserModel extends LocalFlag {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  UserModel(
      {this.id,
        this.name,
        this.email,
        this.phone,
        this.address,}) : super.created();

  UserModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    return data;
  }

  String get initials => name?.isNotEmpty == true ? name!.trim().split(' ').map((l) => l[0]).take(2).join() : '';

  static Future<void> setLocal(UserModel o) async {
    final box = GetStorage();
    return box.write("userData", o.toJson());
  }

  static UserModel? getLocal() {
    final box = GetStorage();
    var a = box.read("userData");
    if (a != null) {
      if (a is UserModel) {
        return a;
      }
      return UserModel.fromJson(a);
    }
    return null;
  }

  // Magic goes here. you can use this function to from json method.
  static UserModel fromJsonModel(Map<String, dynamic> json) =>
      UserModel.fromJson(json);
}
