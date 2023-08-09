import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/view/pages/login/login_screen.dart';
import 'package:mobile/view/pages/login/register_screen.dart';

import '../../../constants/app_constants.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColorLight,
              ],
            )
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              bottom: false,
              minimum: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.2,left: 30,right: 30),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Get.width * 0.6,
                      width: Get.width * 0.6,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          AnimatedPositioned(
                            duration: const Duration(microseconds: 300),
                            left: -((Get.width * 0.3) + 30),
                            child: Image.asset(
                              "assets/images/logo-crop.png",
                              width: Get.width * 0.6,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text("Bitir", style: TextStyle(fontSize: AppConstants.h1Size, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "bitir_login_message".tr,
                      style: const TextStyle(fontSize: AppConstants.h7Size, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      width: Get.width,
                      child: OutlinedButton(
                        onPressed: (){FocusManager.instance.primaryFocus?.unfocus();Get.to(()=>const LoginScreen());},
                        child: Text('Login'.tr, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: Get.width,
                      child: OutlinedButton(
                          onPressed: (){FocusManager.instance.primaryFocus?.unfocus();Get.to(()=>const RegisterScreen());},
                          child: Text('Register'.tr, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                          )),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }
}
