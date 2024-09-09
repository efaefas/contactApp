import 'dart:io';

import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'package:mobile/model/user_model.dart';
import 'package:mobile/service/base_service.dart';

import '../model/response/response_model.dart';

class UserService extends BaseService{

  Future<ResponseModel<UserModel>> add(UserModel user)async{
    try {
      var res = await post("User", user.toJson());
      if (res.statusCode == null) {
        throw SocketException(res.statusText!);
      }
      if (res.bodyString != null) {
        return ResponseModel.fromJson(res.body, UserModel.fromJson);
      }
      return ResponseModel();
    } on SocketException {
      throw "İnternet bağlantınızı kontrol ediniz";
    } catch (e, stackTrace) {
      throw handleError(e, stackTrace: stackTrace);
    }
  }

  Future<ResponseModel<List<UserModel>>> getUsers({String query = ''}) async {
    try {
      var res = await get(
          "User",
          query: {'skip': '0', 'take': '1000', 'search': query}
      );
      if (res.statusCode == null) {
        throw SocketException(res.statusText!);
      }
      if (res.bodyString != null) {
        return ResponseModel<List<UserModel>>.fromJson(res.body, UserModel.fromJsonListModel);
      }
      return ResponseModel<List<UserModel>>();
    } on SocketException {
      throw "Check your internet connection";
    } catch (e, stackTrace) {
      throw handleError(e, stackTrace: stackTrace);
    }
  }


  Future<ResponseModel<UserModel>> getUserById(String id)async{
    try {
      var res = await get("User/$id");
      if (res.statusCode == null) {
        throw SocketException(res.statusText!);
      }
      if (res.bodyString != null) {
        return ResponseModel.fromJson(res.body, UserModel.fromJson);
      }
      return ResponseModel();
    } on SocketException {
      throw "İnternet bağlantınızı kontrol ediniz";
    } catch (e, stackTrace) {
      throw handleError(e, stackTrace: stackTrace);
    }
  }

  Future<ResponseModel<UserModel>> updateUserById(String id, UserModel user)async{
    try {
      var res = await put("User/$id", user.toJson());
      if (res.statusCode == null) {
        throw SocketException(res.statusText!);
      }
      if (res.bodyString != null) {
        return ResponseModel.fromJson(res.body, UserModel.fromJson);
      }
      return ResponseModel();
    } on SocketException {
      throw "İnternet bağlantınızı kontrol ediniz";
    } catch (e, stackTrace) {
      throw handleError(e, stackTrace: stackTrace);
    }
  }
  Future<ResponseModel<UserModel>> removeUserById(String id)async{
    try {
      var res = await delete("User/$id");
      if (res.statusCode == null) {
        throw SocketException(res.statusText!);
      }
      if (res.bodyString != null) {
        return ResponseModel.fromJson(res.body, UserModel.fromJson);
      }
      return ResponseModel();
    } on SocketException {
      throw "İnternet bağlantınızı kontrol ediniz";
    } catch (e, stackTrace) {
      throw handleError(e, stackTrace: stackTrace);
    }
  }

  Future<ResponseModel<String>> uploadImage(File file) async {
    final params = FormData({
      'image': MultipartFile(
        await file.readAsBytes(),
        filename: file.path.split('/').last,
      ),
    });

    try {
      final response = await post("User/UploadImage", params);

      if (response.statusCode == 200) {
        return ResponseModel<String>.fromJson(response.body, (data) => data['imageUrl']);
      } else {
        throw Exception('Failed to upload image: ${response.body}');
      }
    } on SocketException {
      throw "Check your internet connection.";
    } catch (e) {
      throw "Error: ${e.toString()}";
    }
  }

}