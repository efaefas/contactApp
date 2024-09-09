import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/controller/base_controller.dart';
import 'package:mobile/service/user_service.dart';

import '../model/user_model.dart';
import '../util/get_snackbar_utils.dart';

class ContactsScreenController extends BaseController {
  final userService = Get.put(UserService());
  final userList = RxList<UserModel>([]);
  final newUser = Rx<UserModel>(UserModel());
  final picker = ImagePicker();
  final isEditMode = false.obs;
  final uploadedImageUrl = ''.obs;
  var isDoneButtonEnabled = false.obs;
  final RxList<String> userIds = <String>[].obs;
  final searchInput = "".obs;

  @override
  void onInit() {
    getUsers();
    super.onInit();
  }

  Future<void> addUser() async {
    if (newUser.value.firstName == null || newUser.value.lastName == null) {
      GetSnackbarUtils.error("Error", "Please provide the necessary information.");
      return;
    }
    try {
      var res = await userService.add(newUser.value);
      if (res.data != null) {
        userList.add(res.data!);
        newUser.value = UserModel();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getUsers() async {
    try {
      var res = await userService.getUsers();
      if (res.data != null) {
        userList(res.data!);
        userIds.clear();
        userIds.addAll(res.data!.map((user) => user.id!));
      }
    } catch (e) {
      GetSnackbarUtils.error("Error", e.toString());
    }
  }


  void getUserById(String id) async {
    try {
      var res = await userService.getUserById(id);
      if (res.data != null) {
        newUser(res.data!);
      } else {
        GetSnackbarUtils.error("Error", res.messages ?? "Unexpected error occurred");
      }
    } catch (e) {
      GetSnackbarUtils.error("Error", e);
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      var res = await userService.updateUserById(user.id!, user);
      if (res.data != null) {
        user = res.data!;
        getUsers();
        GetSnackbarUtils.success("Success", "Changes have been applied successfully");
      } else {
        GetSnackbarUtils.error("Error", res.messages ?? "Unexpected error occurred");
      }
    } catch (e) {
      GetSnackbarUtils.error("Error", e);
    }
  }

  Future<void> removeUser(String id) async {
    try {
      var res = await userService.removeUserById(id);
      if (res.isSuccess) {
        userList.removeWhere((user) => user.id == id);
        GetSnackbarUtils.success("Success", "User removed successfully");
      } else {
        GetSnackbarUtils.error("Error", res.messages ?? "Unexpected error occurred");
      }
    } catch (e) {
      GetSnackbarUtils.error("Error", e);
    }
  }

  Future<void> uploadImage(File file, UserModel user) async {
    try {
      var res = await userService.uploadImage(file);
      if (res.success == true && res.data != null) {
        user.profileImageUrl = res.data;
       // uploadedImageUrl(res.data);
        updateUser(user);
        GetSnackbarUtils.success("Success", "Image uploaded successfully: ${res.data}");
      } else {
        GetSnackbarUtils.error("Error", res.messages?.join(", ") ?? "An unexpected error occurred.");
      }
    } catch (e) {
      GetSnackbarUtils.error("Error", e.toString());
    }
  }

  Future<void> captureImage(UserModel user) async {
    try {
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final fileExtension = file.path.split('.').last.toLowerCase();
        if (fileExtension == 'png' || fileExtension == 'jpg' || fileExtension == 'jpeg') {
          await uploadImage(file, user);
        } else {
          GetSnackbarUtils.error("Error", "Invalid file format. Only PNG and JPG are allowed.");
        }
      } else {
        GetSnackbarUtils.error("Error", "No image captured.");
      }
    } catch (e) {
      GetSnackbarUtils.error("Error", e.toString());
    }
  }

  Future<void> pickImageFromGallery(UserModel user) async {
    try {
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final fileExtension = file.path.split('.').last.toLowerCase();
        if (fileExtension == 'png' || fileExtension == 'jpg' || fileExtension == 'jpeg') {
          await uploadImage(file, user);
        } else {
          GetSnackbarUtils.error("Error", "Invalid file format. Only PNG and JPG are allowed.");
        }
      } else {
        GetSnackbarUtils.error("Error", "No image selected.");
      }
    } catch (e) {
      GetSnackbarUtils.error("Error", e.toString());
    }
  }
  void checkInputFields() {
    isDoneButtonEnabled.value =
        newUser.value.firstName!= null && newUser.value.lastName!= null && newUser.value.phoneNumber!= null;
  }

  void searchUsers(String query) async {
    if (query.isEmpty) {
      getUsers();
      return;
    }

    try {
      var res = await userService.getUsers(query: query);
      if (res.data != null) {
        userList(res.data!);
      } else {
        userList([]);
      }
    } catch (e) {
      GetSnackbarUtils.error("Error", e.toString());
    }
  }


}

