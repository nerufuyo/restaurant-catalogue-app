// ignore_for_file: avoid_print

import 'dart:math';
import 'dart:convert';
import 'package:restaurant_catalog_submission_akhir/resource/model/restaurant_model.dart';
import 'package:restaurant_catalog_submission_akhir/resource/response/restaurant_list_response.dart';
import 'package:restaurant_catalog_submission_akhir/resource/util/navigation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = const IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        print('notification payload: ' + payload);
      }
      selectNotificationSubject.add(payload ?? 'empty payload');
    });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      RestaurantListFunction response) async {
    var _channelId = '1';
    var _channelName = 'channel_01';

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        _channelId, _channelName,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: const DefaultStyleInformation(true, true));
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    var titleNotifications = '<b>Restaurant<b>';
    var randomRestaurant = Random().nextInt(response.restaurants.length - 1);
    var title = response.restaurants[randomRestaurant].name;

    await flutterLocalNotificationsPlugin.show(
        0, title, titleNotifications, platformChannelSpecifics,
        payload: json.encode(response.restaurants[randomRestaurant].toJson()));
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen((String payload) async {
      var data = Restaurants.fromJson(json.decode(payload));
      Navigation.intentWithData(route, data);
    });
  }
}
