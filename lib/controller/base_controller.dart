import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../model/user_model.dart';

abstract class BaseController extends GetxController with WidgetsBindingObserver {
  final user = UserModel.getLocal().obs;

  late StreamSubscription<ConnectivityResult> subscription;
  late bool isOnline = false;
  late bool _didPaused = false;

  //local storages
  GetStorage storage = GetStorage();


  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    _checkConnection();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      isOnline = result != ConnectivityResult.none;
      if(isOnline) connected();
    });
    storage.listenKey('userData', (value) {
      user(UserModel.getLocal());
    });
    super.onInit();
  }

  void _checkConnection() async {
    isOnline = (await (Connectivity().checkConnectivity())) != ConnectivityResult.none;
    if(isOnline) connected();
  }

  void connected(){

  }

  void appResumed(){

  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    switch(state){
      case AppLifecycleState.resumed:
        if(_didPaused) {
          _didPaused = false;
          appResumed();
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        _didPaused = true;
        break;
      case AppLifecycleState.detached:
        break;
    }
  }
}