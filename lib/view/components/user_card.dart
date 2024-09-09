import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/model/user_model.dart';

import '../../constants/app_constants.dart';

class UserCard {
  static Widget userListCard(UserModel user, void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        width: Get.width * 0.9,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundImage: user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty
                      ? NetworkImage(user.profileImageUrl!)
                      : null,
                  child: user.profileImageUrl == null || user.profileImageUrl!.isEmpty
                      ? const Icon(Icons.person, size: 34)
                      : null,
                ),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: AppConstants.h7Size,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '${user.firstName} ${user.lastName}\n',
                        style: const TextStyle(
                            fontFamily: 'Nunito',
                          color: Colors.black,
                            fontSize: AppConstants.h7Size
                        ),
                      ),
                      TextSpan(
                        text: user.phoneNumber,
                        style: const TextStyle(
                            fontFamily: 'Nunito',
                          color: Colors.grey,
                          fontSize: AppConstants.h8Size
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
