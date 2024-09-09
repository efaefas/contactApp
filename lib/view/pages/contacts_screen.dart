import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/contacts_screen_controller.dart';

class ContactsScreen extends StatelessWidget {
  static const String routePath = "/contacts";
  final controller = Get.put( ContactsScreenController());
   ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Contacts'),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ) ,
      body: Center(
        child:  TextButton(
            onPressed: () {
              controller.addUser();
            }, child:const Text('Add User')),
      ),
    );

  }
}