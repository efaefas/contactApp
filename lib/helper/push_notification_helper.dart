import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationHelper {
  String? fcmToken;
  PushNotificationHelper._();

  factory PushNotificationHelper() => _instance;

  static final PushNotificationHelper _instance = PushNotificationHelper._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _initialized = false;

  Future<void> init(void Function(RemoteMessage) handler) async {
    if (!_initialized) {
      FirebaseMessaging.instance.subscribeToTopic("all");
      /*
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          GetSnackbarUtils.success(message.notification!.title!, message.notification!.body!,
              onTap: () => handler(message));
        }
      });

       */
      fcmToken = await _firebaseMessaging.getToken();

      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      _initialized = true;
    }
  }

  Future<void> setupInteractedMessage(void Function(RemoteMessage) handler) async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handler(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(handler);
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //print("Handling a background message: ${message.messageId}");
}
