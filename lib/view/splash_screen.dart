import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/constants/app_constants.dart';
import 'package:mobile/model/user_model.dart';
import 'package:mobile/view/components/user_card.dart';
import 'package:mobile/view/shared/basic_input_field.dart';

import '../controller/contacts_screen_controller.dart';

class ContactsScreen extends StatelessWidget {
  static const String routePath = "/splash";
  final ContactsScreenController controller =
      Get.put(ContactsScreenController());

  ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: AppConstants.pageColor,
        appBar: AppBar(
          title: Row(
            children: [
              SizedBox(
                width: Get.width * 0.05,
              ),
              const Text(
                'Contacts',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  _addNewContact(context);
                },
                icon: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    )),
              ),
            ],
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: BasicInputField(
                  hint: "Search by name",
                  prefixIcon: Icons.search,
                  textInputType: TextInputType.text,
                  enabledBorderColor: Colors.white,
                  fillColor: Colors.white,
                  onChanged: (x) {
                    controller.searchUsers(x);
                  },
                ),
              ),
              if (controller.userList.isEmpty)
                SizedBox(
                  height: Get.height * 0.25,
                ),
              Obx(() {
                return  controller.userList.isNotEmpty
                    ? Expanded(
                  child: ListView.builder(
                    itemCount: controller.userList.length,
                    itemBuilder: (context, index) {
                      return UserCard.userListCard(
                        controller.userList[index],
                            () {
                          _editUser(context, controller.userList[index]);
                        },
                      );
                    },
                  ),
                )
                    : Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.withOpacity(0.6),
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: Get.height * 0.05,
                        )),
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    const Text(
                      'No Contacts',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: AppConstants.h6Size),
                    ),
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    const Text(
                      "Contacts you've added will appear here",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: AppConstants.h7Size),
                    ),
                    TextButton(
                      onPressed: () {
                        _addNewContact(context);
                      },
                      child: const Text(
                        'Create New Contact',
                        style: TextStyle(
                            fontSize: AppConstants.h7Size,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                );
              })

            ],
          ),
        ),
      );
    });
  }

  Future _addNewContact(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.92,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: Get.height * 0.02,
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                          fontSize: AppConstants.h7Size),
                    ),
                  ),
                ),
                const Spacer(),
                const Text(
                  'New Contact',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: AppConstants.h7Size),
                ),
                const Spacer(),
                Obx(
                  () => TextButton(
                    onPressed: controller.isDoneButtonEnabled.value
                        ? () async{
                          await  controller.addUser();
                           await controller.getUsers();
                            Get.back();
                          }
                        : null,
                    child: Text(
                      'Done',
                      style: TextStyle(
                        color: controller.isDoneButtonEnabled.value
                            ? Colors.blue
                            : Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: AppConstants.h7Size,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            controller.uploadedImageUrl.isNotEmpty
                ? CircleAvatar(
              radius: 90,
              backgroundImage: CachedNetworkImageProvider(controller.uploadedImageUrl.value),
            )

                : Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.8),
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: Get.height * 0.2,
                    )),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => _showPhotoOptions(context, controller.newUser.value),
              child: const Text(
                'Add Photo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppConstants.h7Size,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: Get.width * 0.9,
              height: 43,
              child: BasicInputField(
                enabledBorderColor: Colors.grey,
                hint: "First name",
                textInputType: TextInputType.text,
                fillColor: Colors.grey[200],
                onChanged: (x) {
                  controller.newUser.value.firstName = x;
                  controller.newUser.refresh();
                  controller.checkInputFields();
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: Get.width * 0.9,
              height: 43,
              child: BasicInputField(
                enabledBorderColor: Colors.grey,
                hint: "Last name",
                textInputType: TextInputType.text,
                fillColor: Colors.grey[200],
                onChanged: (x) {
                  controller.newUser.value.lastName = x;
                  controller.newUser.refresh();
                  controller.checkInputFields();
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: Get.width * 0.9,
              height: 43,
              child: BasicInputField(
                enabledBorderColor: Colors.grey,
                hint: "Phone number",
                textInputType: TextInputType.phone,
                fillColor: Colors.grey[200],
                onChanged: (x) {
                  controller.newUser.value.phoneNumber = x;
                  controller.newUser.refresh();
                  controller.checkInputFields();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _editUser(BuildContext context, UserModel user) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Obx(() {
          return FractionallySizedBox(
            heightFactor: 0.92,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10, top: 20),
                      child: TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                            fontSize: AppConstants.h7Size,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.only(right: 10, top: 20),
                      child: controller.isEditMode.value
                          ? TextButton(
                        onPressed: () async {
                            debugPrint('Updating user: ${user.firstName} ${user.lastName}');
                           await  controller.updateUser(user);
                            await controller.getUsers();
                            Get.back();
                            controller.isEditMode.toggle();
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(
                            color: controller.isDoneButtonEnabled.value
                                ? Colors.blue
                                : Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: AppConstants.h7Size,
                          ),
                        ),
                      )
                          : TextButton(
                        onPressed: () {
                          controller.isEditMode.toggle();
                        },
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            color: controller.isDoneButtonEnabled.value
                                ? Colors.blue
                                : Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: AppConstants.h7Size,
                          ),
                        ),
                      ),
                    )

                  ],
                ),
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 90,
                  backgroundImage: user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty
                      ? CachedNetworkImageProvider(user.profileImageUrl!)
                      : null,
                  child: user.profileImageUrl == null || user.profileImageUrl!.isEmpty
                      ? Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.withOpacity(0.8),
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: Get.height * 0.2,
                      ))
                      : null,
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => _showPhotoOptions(context, user),
                  child: const Text(
                    'Change Photo',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppConstants.h7Size,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: Get.width * 0.9,
                  height: 43,
                  child: (controller.isEditMode.value)
                      ? BasicInputField(
                    enabledBorderColor: Colors.grey,
                    initialValue: user.firstName ?? '',
                    fillColor: Colors.grey[200],
                    hint: "First name",
                    textInputType: TextInputType.text,
                    onChanged: (x) {
                      user.firstName = x;
                      controller.checkInputFields();
                    },
                  )
                      : Column(
                    children: [
                      _editModeView(context, user.firstName ?? ''),
                      Divider(color: Colors.black.withOpacity(0.4), thickness: 1,),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: Get.width * 0.9,
                  height: 43,
                  child: (controller.isEditMode.value)
                      ? BasicInputField(
                    fillColor: Colors.grey[200],
                    initialValue: user.lastName ?? '',
                    enabledBorderColor: Colors.grey,
                    hint: "Last name",
                    textInputType: TextInputType.text,
                    onChanged: (x) {
                      user.lastName = x;
                      controller.checkInputFields();
                    },
                  )
                      : Column(
                    children: [
                      _editModeView(context, user.lastName ?? ''),
                      Divider(color: Colors.black.withOpacity(0.4), thickness: 1,),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: Get.width * 0.9,
                  height: 43,
                  child: (controller.isEditMode.value)
                      ? BasicInputField(
                    initialValue: user.phoneNumber ?? '',
                    enabledBorderColor: Colors.grey,
                    fillColor: Colors.grey[200],
                    hint: "Phone number",
                    textInputType: TextInputType.phone,
                    onChanged: (x) {
                      user.phoneNumber = x;
                      controller.checkInputFields();
                    },
                  )
                      : Column(
                    children: [
                      _editModeView(context, user.phoneNumber ?? ''),
                      Divider(color: Colors.black.withOpacity(0.4), thickness: 1,),
                    ],
                  ),
                ),
                (!controller.isEditMode.value)
                    ? Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextButton(

                    onPressed: ()async {
                      Get.back();
                      showDeleteConfirmationBottomSheet(user.id!);
                    },
                    child: const Text(
                      'Delete Contact',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppConstants.h7Size,
                        color: Colors.red,
                      ),
                    ),
                  ),
                )
                    : Container(),
              ],
            ),
          );
        });
      },
    );
  }


  void _showPhotoOptions(BuildContext context, UserModel user) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: null,
                  title: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_rounded),
                      SizedBox(width: 10),
                      Text('Camera', style: TextStyle(fontWeight: FontWeight.bold, fontSize:  AppConstants.h6Size) ,),
                    ],
                  ),
                  onTap: () async{
                    controller.captureImage(user);
                   Get.back();
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: null,
                  title: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.photo_library_rounded),
                      SizedBox(width: 10),
                      Text('Gallery', style: TextStyle(fontWeight: FontWeight.bold, fontSize:  AppConstants.h6Size) ,),
                    ],
                  ),
                  onTap: () async{
                    controller.pickImageFromGallery(user);
                Get.back();
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: null,
                  title: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Cancel',
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize:  AppConstants.h6Size),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }



  Widget _editModeView(BuildContext context, String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Text(
          text,
          style: const TextStyle(fontWeight:  FontWeight.bold, fontSize: AppConstants.h7Size),
        ),
      ),
    );
  }
  void showDeleteConfirmationBottomSheet(String userId) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Delete Account?',
              style: TextStyle(
                fontSize: AppConstants.h5Size,
               fontWeight: FontWeight.bold ,
               color: Colors.red ,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            Container(
              margin:  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              decoration:  BoxDecoration(
                color: Colors.grey.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      debugPrint('Deleting user with ID: $userId');
                    controller.  removeUser(userId);
                      Get.back();
                    },
                    child: const Text(
                      'Yes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppConstants.h7Size,
                          color: Colors.black
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin:  const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
              decoration:  BoxDecoration(
                color: Colors.grey.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text(
                      'No',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      isDismissible: true,
      enableDrag: true,
    );
  }

}
