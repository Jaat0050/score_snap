import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(message) {
  Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, fontSize: 14.0);
}

const AndroidNotificationDetails androidChannel = AndroidNotificationDetails('1', 'Events', importance: Importance.high, icon: '@mipmap/ic_launcher', color: Colors.green, styleInformation: BigTextStyleInformation(''));

const NotificationDetails platformChannel = NotificationDetails(android: androidChannel);

void showLocalNotification(String title, String body) async {
  await FlutterLocalNotificationsPlugin().show(41, title, body, platformChannel);
}
