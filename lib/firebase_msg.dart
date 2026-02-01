import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMsg  {

     final msgService = FirebaseMessaging.instance;

     initFCM() async {

      await msgService.requestPermission();

      var token = await msgService.getToken();

      print('FCM Token: $token');

      FirebaseMessaging.onBackgroundMessage(HandleNotification);
      FirebaseMessaging.onMessage.listen(HandleNotification);

     }


}

Future<void> HandleNotification(RemoteMessage message) async {

  print('Handling a background message: ${message.messageId}');

}